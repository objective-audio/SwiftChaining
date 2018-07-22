//
//  ArrayHolder.swift
//

import Foundation

final public class ArrayHolder<Element: Relayable> {
    public enum Event {
        case all([Element])
        case inserted(Element, at: Int)
        case removed(Element, at: Int)
        case replaced(Element, at: Int)
        case relayed(Element, at: Int, value: Element.SendValue)
    }
    
    public let core = SenderCore<ArrayHolder>()
    
    private typealias ElementPair = (element: Element, observer: AnyObserver?)
    
    public var elements: [Element] { return self.elementPairs.map { $0.element } }
    private var elementPairs: [ElementPair] = []
    
    public var count: Int { return self.elements.count }
    
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
        let index = self.elements.count
        self.insert(element, at: index)
    }
    
    public func insert(_ element: Element, at index: Int) {
        self.insert(element: element, at: index, chaining: nil)
    }
    
    @discardableResult
    public func remove(at index: Int) -> Element {
        let pair = self.elementPairs.remove(at: index)
        
        if let observer = pair.observer {
            observer.invalidate()
        }
        
        self.core.broadcast(value: .removed(pair.element, at: index))
        
        return pair.element
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        for pair in self.elementPairs {
            if let observer = pair.observer {
                observer.invalidate()
            }
        }
        
        self.elementPairs.removeAll(keepingCapacity: keepCapacity)
        
        self.core.broadcast(value: .all([]))
    }
    
    public func element(at index: Int) -> Element {
        return self.elements[index]
    }
    
    public func reserveCapacity(_ capacity: Int) {
        self.elementPairs.reserveCapacity(capacity)
    }
    
    public var capacity: Int {
        return self.elementPairs.capacity
    }
    
    public var first: Element? {
        return self.elementPairs.first?.element
    }
    
    public var last: Element? {
        return self.elementPairs.last?.element
    }
    
    public subscript(index: Int) -> Element {
        return self.element(at: index)
    }
}

extension ArrayHolder /* private */ {
    private func insert(element: Element, at index: Int, chaining: ((Int, Element) -> AnyObserver)?) {
        self.elementPairs.insert((element, chaining?(index, element)), at: index)
        self.core.broadcast(value: .inserted(element, at: index))
    }
    
    private func replace(_ elements: [Element], chaining: ((Int, Element) -> AnyObserver)?) {
        self.elementPairs = elements.enumerated().map { ($0.1, chaining?($0.0, $0.1)) }
        self.core.broadcast(value: .all(elements))
    }
    
    private func replace(_ element: Element, at index: Int, chaining: ((Int, Element) -> AnyObserver)?) {
        self.elementPairs.replaceSubrange(index...index, with: [(element, chaining?(index, element))])
        self.core.broadcast(value: .replaced(element, at: index))
    }
}

extension ArrayHolder: Fetchable {
    public typealias SendValue = Event
    
    public func fetchedValue() -> SendValue {
        return .all(self.elements)
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
        let index = self.elements.count
        self.insert(element, at: index)
    }
    
    public func insert(_ element: Element, at index: Int) {
        self.insert(element: element, at: index, chaining: self.elementChaining())
    }
    
    private func elementChaining() -> ((Int, Element) -> AnyObserver) {
        return { (index: Int, element: Element) in
            element.chain().do({ [weak self] value in
                if let sself = self {
                    sself.core.broadcast(value: .relayed(sself.elements[index], at: index, value: value))
                }
            }).end()
        }
    }
}
