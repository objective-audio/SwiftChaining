//
//  ArrayHolder.swift
//

import Foundation

public protocol ArrayReadable {
    associatedtype Element
    
    var rawArray: [Element] { get }
}

extension ArrayReadable {
    public func element(at index: Int) -> Element {
        return self.rawArray[index]
    }
    
    public var count: Int { return self.rawArray.count }
    public var capacity: Int { return self.rawArray.capacity }
    public var first: Element? { return self.rawArray.first }
    public var last: Element? { return self.rawArray.last }
    
    public subscript(index: Int) -> Element {
        get { return self.element(at: index) }
    }
}

extension Alias: ArrayReadable where T: ArrayReadable {
    public typealias Element = T.Element
    
    public var rawArray: [T.Element] { return self.sender.rawArray }
}

final public class ArrayHolder<E> {
    public typealias Element = E
    
    public private(set) var rawArray: [Element] = []
    
    public enum Event {
        case fetched([Element])
        case any([Element])
        case inserted(at: Int, element: Element)
        case removed(at: Int, element: Element)
        case replaced(at: Int, element: Element)
        case moved(from: Int, to: Int, element: Element)
    }
    
    public init() {}
    
    public convenience init(_ elements: [Element]) {
        self.init()
        
        self.replace(elements)
    }
    
    public func replace(_ elements: [Element]) {
        self.rawArray = elements
        self.broadcast(value: .any(elements))
    }
    
    public func replace(_ element: Element, at index: Int) {
        self.rawArray.replaceSubrange(index...index, with: [element])
        self.broadcast(value: .replaced(at: index, element: element))
    }
    
    public func append(_ element: Element) {
        let index = self.rawArray.count
        self.insert(element, at: index)
    }
    
    public func insert(_ element: Element, at index: Int) {
        self.rawArray.insert(element, at: index)
        self.broadcast(value: .inserted(at: index, element: element))
    }
    
    @discardableResult
    public func remove(at index: Int) -> Element {
        let element = self.rawArray.remove(at: index)
        self.broadcast(value: .removed(at: index, element: element))
        return element
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        if self.rawArray.count == 0 {
            return
        }
        
        self.rawArray.removeAll(keepingCapacity: keepCapacity)
        
        self.broadcast(value: .any([]))
    }
    
    public func move(from: Int, to: Int) {
        if from == to { return }
        
        let element = self.rawArray.remove(at: from)
        self.rawArray.insert(element, at: to)
        self.broadcast(value: .moved(from: from, to: to, element: element))
    }
    
    public func reserveCapacity(_ capacity: Int) {
        self.rawArray.reserveCapacity(capacity)
    }
    
    public subscript(index: Int) -> Element {
        get { return self.element(at: index) }
        set(element) { self.replace(element, at: index) }
    }
}

extension ArrayHolder: ArrayReadable {}

extension ArrayHolder: Fetchable {
    public typealias SendValue = Event
    
    public func fetchedValue() -> Event? {
        return .fetched(self.rawArray)
    }
}
