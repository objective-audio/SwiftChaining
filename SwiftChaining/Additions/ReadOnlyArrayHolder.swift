//
//  ReadOnlyArrayHolder.swift
//

import Foundation

public typealias ReadOnlyArrayHolder<Element> = ReadOnlyArrayHolderImpl<Element, Element>
public typealias ReadOnlyRelayableArrayHolder<Element: Sendable> = ReadOnlyArrayHolderImpl<Element, Element.SendValue>

public class ReadOnlyArrayHolderImpl<Element, Relay> {
    private let holder: ArrayHolderImpl<Element, Relay>
    
    public var rawArray: [Element] { return self.holder.rawArray }
    
    public var count: Int { return self.holder.count }
    
    public init(_ holder: ArrayHolderImpl<Element, Relay>) {
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
    
    public func chain() -> ArrayHolderImpl<Element, Relay>.SenderChain {
        return self.holder.chain()
    }
}
