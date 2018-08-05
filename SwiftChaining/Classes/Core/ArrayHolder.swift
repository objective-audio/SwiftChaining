//
//  ArrayHolder.swift
//

import Foundation

final public class ArrayHolder<Element: Relayable> {
    public enum Event {
        case all([Element])
        case inserted(at: Int, element: Element)
        case removed(at: Int, element: Element)
        case replaced(at: Int, element: Element)
        case relayed(Element.SendValue, at: Int, element: Element)
    }
    
    public let core = SenderCore<ArrayHolder>()
    
    private class ElementPair {
        let element: Element
        var observer: AnyObserver?
        
        init(_ element: Element) {
            self.element = element
        }
    }
    
    public var rawArray: [Element] { return self.pairArray.map { $0.element } }
    private var pairArray: [ElementPair] = []
    
    public var count: Int { return self.pairArray.count }
    
    public init() {}
    
    public convenience init(_ elements: [Element]) {
        self.init()
        
        self.replace(elements)
    }
    
    public func replace(_ elements: [Element]) {
        self.replace(elements, chaining: nil)
    }
    
    public func replace(_ element: Element, at index: Int) {
        self.replace(element, at: index, chaining: nil)
    }
    
    public func append(_ element: Element) {
        let index = self.pairArray.count
        self.insert(element, at: index)
    }
    
    public func insert(_ element: Element, at index: Int) {
        self.insert(element: element, at: index, chaining: nil)
    }
    
    @discardableResult
    public func remove(at index: Int) -> Element {
        let pair = self.pairArray.remove(at: index)
        
        if let observer = pair.observer {
            observer.invalidate()
        }
        
        self.core.broadcast(value: .removed(at: index, element: pair.element))
        
        return pair.element
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        for pair in self.pairArray {
            if let observer = pair.observer {
                observer.invalidate()
            }
        }
        
        self.pairArray.removeAll(keepingCapacity: keepCapacity)
        
        self.core.broadcast(value: .all([]))
    }
    
    public func element(at index: Int) -> Element {
        return self.pairArray[index].element
    }
    
    public func reserveCapacity(_ capacity: Int) {
        self.pairArray.reserveCapacity(capacity)
    }
    
    public var capacity: Int {
        return self.pairArray.capacity
    }
    
    public var first: Element? {
        return self.pairArray.first?.element
    }
    
    public var last: Element? {
        return self.pairArray.last?.element
    }
    
    public subscript(index: Int) -> Element {
        get { return self.element(at: index) }
        set(element) { self.replace(element, at: index) }
    }
}

extension ArrayHolder /* private */ {
    private typealias ChainingHandler = (ElementPair) -> Void
    
    private func insert(element: Element, at index: Int, chaining: ChainingHandler?) {
        let pair = ElementPair(element)
        chaining?(pair)
        self.pairArray.insert(pair, at: index)
        self.core.broadcast(value: .inserted(at: index, element: element))
    }
    
    private func replace(_ elements: [Element], chaining: ChainingHandler?) {
        self.pairArray = elements.enumerated().map {
            let pair = ElementPair($0.1)
            chaining?(pair)
            return pair
        }
        self.core.broadcast(value: .all(elements))
    }
    
    private func replace(_ element: Element, at index: Int, chaining: ChainingHandler?) {
        let pair = ElementPair(element)
        chaining?(pair)
        self.pairArray.replaceSubrange(index...index, with: [pair])
        self.core.broadcast(value: .replaced(at: index, element: element))
    }
}

extension ArrayHolder: Fetchable {
    public typealias SendValue = Event
    
    public func fetchedValue() -> SendValue {
        return .all(self.rawArray)
    }
}

// MARK: - Element: Sendable

extension ArrayHolder where Element: Sendable {
    public convenience init(_ elements: [Element]) {
        self.init()
        
        self.replace(elements)
    }
    
    public func replace(_ elements: [Element]) {
        self.replace(elements, chaining: self.elementChaining())
    }
    
    public func replace(_ element: Element, at index: Int) {
        self.replace(element, at: index, chaining: self.elementChaining())
    }
    
    public func append(_ element: Element) {
        let index = self.pairArray.count
        self.insert(element, at: index)
    }
    
    public func insert(_ element: Element, at index: Int) {
        self.insert(element: element, at: index, chaining: self.elementChaining())
    }
    
    public subscript(index: Int) -> Element {
        get { return self.element(at: index) }
        set(element) { self.replace(element, at: index) }
    }
    
    private func elementChaining() -> ChainingHandler {
        return { (pair: ElementPair) in
            pair.observer = pair.element.chain().do({ [weak self, weak pair] value in
                if let sself = self, let pair = pair {
                    if let index = sself.pairArray.index(where: { return ObjectIdentifier($0) == ObjectIdentifier(pair) }) {
                        sself.core.broadcast(value: .relayed(value, at: index, element: sself.pairArray[index].element))
                    }
                }
            }).end()
        }
    }
}
