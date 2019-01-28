//
//  Alias.swift
//

import Foundation

public struct Alias<T: Sendable> {
    internal var sender: T
    
    public init(_ sender: T) {
        self.sender = sender
    }
    
    public func chain() -> T.SenderChain {
        return self.sender.chain()
    }
}
