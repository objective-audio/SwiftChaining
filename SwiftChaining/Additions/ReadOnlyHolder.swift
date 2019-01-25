//
//  ReadOnlyHolder.swift
//

import Foundation

public class ReadOnlyHolder<T> {
    private let holder: Holder<T>
    
    public var value: T { return self.holder.value }
    
    public init(_ holder: Holder<T>) {
        self.holder = holder
    }
    
    public func chain() -> Holder<T>.SenderChain {
        return self.holder.chain()
    }
}

public class ReadOnlyRelayableHolder<T: Sendable> {
    private let holder: RelayableHolder<T>
    
    public var value: T { return self.holder.value }
    
    public init(_ holder: RelayableHolder<T>) {
        self.holder = holder
    }
    
    public func chain() -> RelayableHolder<T>.SenderChain {
        return self.holder.chain()
    }
}
