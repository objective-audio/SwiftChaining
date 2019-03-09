//
//  ArrayHolder.swift
//

import Foundation

public protocol ArrayReadable {
    associatedtype Element
    
    var raw: [Element] { get }
}

extension ArrayReadable {
    public func element(at index: Int) -> Element {
        return self.raw[index]
    }
    
    public var count: Int { return self.raw.count }
    public var capacity: Int { return self.raw.capacity }
    public var first: Element? { return self.raw.first }
    public var last: Element? { return self.raw.last }
    
    public subscript(index: Int) -> Element {
        get { return self.element(at: index) }
    }
}

final public class ArrayHolder<E> {
    public typealias Element = E
    
    public private(set) var raw: [Element] = []
    
    public enum Event {
        case fetched([Element])
        case set([Element])
        case inserted(at: Int, element: Element)
        case removed(at: Int, element: Element)
        case replaced(at: Int, element: Element)
        case moved(from: Int, to: Int, element: Element)
    }
    
    public enum Action {
        case set([Element])
        case insert(element: Element, at: Int)
        case remove(at: Int)
        case replace(element: Element, at: Int)
        case move(at: Int, to: Int)
    }
    
    public init() {}
    
    public convenience init(_ elements: [Element]) {
        self.init()
        
        self.set(elements)
    }
    
    public func set(_ elements: [Element]) {
        self.raw = elements
        self.broadcast(value: .set(elements))
    }
    
    public func replace(_ element: Element, at index: Int) {
        self.raw.replaceSubrange(index...index, with: [element])
        self.broadcast(value: .replaced(at: index, element: element))
    }
    
    public func append(_ element: Element) {
        let index = self.raw.count
        self.insert(element, at: index)
    }
    
    public func insert(_ element: Element, at index: Int) {
        self.raw.insert(element, at: index)
        self.broadcast(value: .inserted(at: index, element: element))
    }
    
    @discardableResult
    public func remove(at index: Int) -> Element {
        let element = self.raw.remove(at: index)
        self.broadcast(value: .removed(at: index, element: element))
        return element
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        if self.raw.count == 0 {
            return
        }
        
        self.raw.removeAll(keepingCapacity: keepCapacity)
        
        self.broadcast(value: .set([]))
    }
    
    public func move(at from: Int, to: Int) {
        if from == to { return }
        
        let element = self.raw.remove(at: from)
        self.raw.insert(element, at: to)
        self.broadcast(value: .moved(from: from, to: to, element: element))
    }
    
    public func reserveCapacity(_ capacity: Int) {
        self.raw.reserveCapacity(capacity)
    }
    
    public subscript(index: Int) -> Element {
        get { return self.element(at: index) }
        set(element) { self.replace(element, at: index) }
    }
}

extension ArrayHolder: ArrayReadable {}

extension ArrayHolder: Fetchable {
    public typealias SendValue = Event
    
    public func fetchedValue() -> Event {
        return .fetched(self.raw)
    }
}

extension ArrayHolder: Receivable {
    public typealias ReceiveValue = Action
    
    public func receive(value: Action) {
        switch value {
        case .set(let elements):
            self.set(elements)
        case .insert(let element, let index):
            self.insert(element, at: index)
        case .remove(let index):
            self.remove(at: index)
        case .replace(let element, let index):
            self.replace(element, at: index)
        case .move(let fromIndex, let toIndex):
            self.move(at: fromIndex, to: toIndex)
        }
    }
}
