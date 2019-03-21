//
//  RelayableArrayHolder.swift
//

import Foundation

final public class RelayableArrayHolder<Element: Sendable> {
    public private(set) var raw: [Element] = []
    
    public var count: Int { return self.raw.count }
    
    public enum Event {
        case fetched([Element])
        case set([Element])
        case inserted(at: Int, element: Element)
        case removed(at: Int, element: Element)
        case replaced(at: Int, element: Element)
        case moved(at: Int, to: Int, element: Element)
        case relayed(Element.ChainValue, at: Int, element: Element)
    }
    
    private class ObserverWrapper {
        var observer: AnyObserver?
    }
    
    private var observerArray: [ObserverWrapper] = []
    
    public init() {}
    
    public convenience init(_ elements: [Element]) {
        self.init()
        
        self.set(elements)
    }
    
    public func reserveCapacity(_ capacity: Int) {
        self.raw.reserveCapacity(capacity)
    }
    
    public subscript(index: Int) -> Element {
        get { return self.element(at: index) }
        set(element) { self.replace(element, at: index) }
    }
    
    private func relayingWrapper(element: Element) -> ObserverWrapper {
        let wrapper = ObserverWrapper()
        wrapper.observer = element.chain().do({ [weak self, weak wrapper] value in
            if let self = self, let wrapper = wrapper {
                if let index = self.observerArray.index(where: { return ObjectIdentifier($0) == ObjectIdentifier(wrapper) }) {
                    self.broadcast(value: .relayed(value, at: index, element: self.raw[index]))
                }
            }
        }).end()
        return wrapper
    }
}

extension RelayableArrayHolder: ArrayReadable {}

extension RelayableArrayHolder: ArrayWritable {
    public typealias ReceiveValue = ArrayAction<Element>
    
    public func set(_ elements: [Element]) {
        for wrapper in self.observerArray {
            if let observer = wrapper.observer {
                observer.invalidate()
            }
        }
        
        self.observerArray.removeAll()
        self.raw.removeAll()
        
        for element in elements {
            let wrapper = self.relayingWrapper(element: element)
            self.observerArray.append(wrapper)
        }
        
        self.raw = elements
        
        self.broadcast(value: .set(elements))
    }
    
    public func replace(_ element: Element, at index: Int) {
        let wrapper = self.relayingWrapper(element: element)
        self.observerArray.replaceSubrange(index...index, with: [wrapper])
        
        self.raw.replaceSubrange(index...index, with: [element])
        self.broadcast(value: .replaced(at: index, element: element))
    }
    
    public func append(_ element: Element) {
        let index = self.raw.count
        self.insert(element, at: index)
    }
    
    public func insert(_ element: Element, at index: Int) {
        let wrapper = self.relayingWrapper(element: element)
        self.observerArray.insert(wrapper, at: index)
        
        self.raw.insert(element, at: index)
        self.broadcast(value: .inserted(at: index, element: element))
    }
    
    @discardableResult
    public func remove(at index: Int) -> Element {
        if index < self.observerArray.count {
            let wrapper = self.observerArray.remove(at: index)
            
            if let observer = wrapper.observer {
                observer.invalidate()
            }
        }
        
        let element = self.raw.remove(at: index)
        
        self.broadcast(value: .removed(at: index, element: element))
        
        return element
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        if self.raw.count == 0 {
            return
        }
        
        for wrapper in self.observerArray {
            if let observer = wrapper.observer {
                observer.invalidate()
            }
        }
        
        self.observerArray.removeAll(keepingCapacity: keepCapacity)
        self.raw.removeAll(keepingCapacity: keepCapacity)
        
        self.broadcast(value: .set([]))
    }
    
    public func move(at from: Int, to: Int) {
        if from == to { return }
        
        let element = self.raw.remove(at: from)
        let wrapper = self.observerArray.remove(at: from)
        
        self.raw.insert(element, at: to)
        self.observerArray.insert(wrapper, at: to)
        
        self.broadcast(value: .moved(at: from, to: to, element: element))
    }
}

extension RelayableArrayHolder: Fetchable {
    public typealias ChainValue = Event
    
    public func fetchedValue() -> Event {
        return .fetched(self.raw)
    }
}
