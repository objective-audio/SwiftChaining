//
//  ArrayHolderAlias.swift
//

import Foundation

public class ArrayAlias<Element> {
    private let holder: ArrayHolder<Element>
    
    public var rawArray: [Element] { return self.holder.rawArray }
    
    public var count: Int { return self.holder.count }
    
    public init(_ holder: ArrayHolder<Element>) {
        self.holder = holder
    }
    
    public func element(at index: Int) -> Element {
        return self.holder.element(at: index)
    }
    
    public var capacity: Int {
        return self.holder.capacity
    }
    
    public var first: Element? {
        return self.holder.first
    }
    
    public var last: Element? {
        return self.holder.last
    }
    
    public func chain() -> ArrayHolder<Element>.SenderChain {
        return self.holder.chain()
    }
}

public class RelayableArrayAlias<Element: Sendable> {
    private let holder: RelayableArrayHolder<Element>
    
    public var rawArray: [Element] { return self.holder.rawArray }
    
    public var count: Int { return self.holder.count }
    
    public init(_ holder: RelayableArrayHolder<Element>) {
        self.holder = holder
    }
    
    public func element(at index: Int) -> Element {
        return self.holder.element(at: index)
    }
    
    public var capacity: Int {
        return self.holder.capacity
    }
    
    public var first: Element? {
        return self.holder.first
    }
    
    public var last: Element? {
        return self.holder.last
    }
    
    public func chain() -> RelayableArrayHolder<Element>.SenderChain {
        return self.holder.chain()
    }
}
