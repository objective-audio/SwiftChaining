//
//  ArrayHolder.swift
//

import Foundation

public typealias ArrayHolder<Element> = ArrayHolderImpl<Element, Element>
public typealias RelayableArrayHolder<Element: Sendable> = ArrayHolderImpl<Element, Element.SendValue>
public typealias ReadOnlyArrayHolder<Element> = ReadOnlyArrayHolderImpl<Element, Element>
public typealias ReadOnlyRelayableArrayHolder<Element: Sendable> = ReadOnlyArrayHolderImpl<Element, Element.SendValue>

public class ReadOnlyArrayHolderImpl<Element, Relay> {
    public let core = SenderCore<ArrayHolderImpl<Element, Relay>>()
    
    public fileprivate(set) var rawArray: [Element] = []
    
    public var count: Int { return self.rawArray.count }
    
    fileprivate init() {}
    
    public func element(at index: Int) -> Element {
        return self.rawArray[index]
    }
    
    public var capacity: Int {
        return self.rawArray.capacity
    }
    
    public var first: Element? {
        return self.rawArray.first
    }
    
    public var last: Element? {
        return self.rawArray.last
    }
    
    public func chain() -> ArrayHolderImpl<Element, Relay>.SenderChain {
        return Chain(joint: self.core.addJoint(sender: self as! ArrayHolderImpl<Element, Relay>), handler: { $0 })
    }
}

final public class ArrayHolderImpl<Element, Relay>: ReadOnlyArrayHolderImpl<Element, Relay> {
    public enum Event {
        case fetched([Element])
        case any([Element])
        case inserted(at: Int, element: Element)
        case removed(at: Int, element: Element)
        case replaced(at: Int, element: Element)
        case relayed(Relay, at: Int, element: Element)
    }
    
    private class ObserverWrapper {
        var observer: AnyObserver?
    }
    
    private var observerArray: [ObserverWrapper] = []
    
    public override init() {}
    
    public convenience init(_ elements: [Element]) {
        self.init()
        
        self.replace(elements)
    }
    
    public func replace(_ elements: [Element]) {
        self.replace(elements, relaying: nil)
    }
    
    public func replace(_ element: Element, at index: Int) {
        self.replace(element, at: index, relaying: nil)
    }
    
    public func append(_ element: Element) {
        let index = self.rawArray.count
        self.insert(element, at: index)
    }
    
    public func insert(_ element: Element, at index: Int) {
        self.insert(element: element, at: index, relaying: nil)
    }
    
    @discardableResult
    public func remove(at index: Int) -> Element {
        if index < self.observerArray.count {
            let wrapper = self.observerArray.remove(at: index)
            
            if let observer = wrapper.observer {
                observer.invalidate()
            }
        }
        
        let element = self.rawArray.remove(at: index)
        
        self.core.broadcast(value: .removed(at: index, element: element))
        
        return element
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        if self.rawArray.count == 0 {
            return
        }
        
        for wrapper in self.observerArray {
            if let observer = wrapper.observer {
                observer.invalidate()
            }
        }
        
        self.observerArray.removeAll(keepingCapacity: keepCapacity)
        self.rawArray.removeAll(keepingCapacity: keepCapacity)
        
        self.core.broadcast(value: .any([]))
    }
    
    public func reserveCapacity(_ capacity: Int) {
        self.rawArray.reserveCapacity(capacity)
    }
    
    public subscript(index: Int) -> Element {
        get { return self.element(at: index) }
        set(element) { self.replace(element, at: index) }
    }
}

extension ArrayHolderImpl /* private */ {
    private typealias RelayingHandler = (Element, ObserverWrapper) -> Void
    
    private func insert(element: Element, at index: Int, relaying: RelayingHandler?) {
        if let relaying = relaying {
            let wrapper = ObserverWrapper()
            relaying(element, wrapper)
            self.observerArray.insert(wrapper, at: index)
        }
        
        self.rawArray.insert(element, at: index)
        self.core.broadcast(value: .inserted(at: index, element: element))
    }
    
    private func replace(_ elements: [Element], relaying: RelayingHandler?) {
        for wrapper in self.observerArray {
            if let observer = wrapper.observer {
                observer.invalidate()
            }
        }
        
        self.observerArray.removeAll()
        self.rawArray.removeAll()
        
        if let relaying = relaying {
            for element in elements {
                let wrapper = ObserverWrapper()
                relaying(element, wrapper)
                self.observerArray.append(wrapper)
            }
        }
        
        self.rawArray = elements
        
        self.core.broadcast(value: .any(elements))
    }
    
    private func replace(_ element: Element, at index: Int, relaying: RelayingHandler?) {
        if let relaying = relaying {
            let wrapper = ObserverWrapper()
            relaying(element, wrapper)
            self.observerArray.replaceSubrange(index...index, with: [wrapper])
        }
        
        self.rawArray.replaceSubrange(index...index, with: [element])
        self.core.broadcast(value: .replaced(at: index, element: element))
    }
}

extension ArrayHolderImpl: Fetchable {
    public typealias SendValue = Event
    
    public func fetchedValue() -> SendValue? {
        return .fetched(self.rawArray)
    }
}

// MARK: - Element: Sendable

extension ArrayHolderImpl where Element: Sendable, Relay == Element.SendValue {
    public convenience init(_ elements: [Element]) {
        self.init()
        
        self.replace(elements)
    }
    
    public func replace(_ elements: [Element]) {
        self.replace(elements, relaying: self.relaying())
    }
    
    public func replace(_ element: Element, at index: Int) {
        self.replace(element, at: index, relaying: self.relaying())
    }
    
    public func append(_ element: Element) {
        let index = self.rawArray.count
        self.insert(element, at: index)
    }
    
    public func insert(_ element: Element, at index: Int) {
        self.insert(element: element, at: index, relaying: self.relaying())
    }
    
    public subscript(index: Int) -> Element {
        get { return self.element(at: index) }
        set(element) { self.replace(element, at: index) }
    }
    
    private func relaying() -> RelayingHandler {
        return { (element: Element, wrapper: ObserverWrapper) in
            wrapper.observer = element.chain().do({ [weak self, weak wrapper] value in
                if let self = self, let wrapper = wrapper {
                    if let index = self.observerArray.index(where: { return ObjectIdentifier($0) == ObjectIdentifier(wrapper) }) {
                        self.core.broadcast(value: .relayed(value, at: index, element: self.rawArray[index]))
                    }
                }
            }).end()
        }
    }
}
