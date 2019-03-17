//
//  Retainer.swift
//

import Foundation

public struct Retainer<T> {
    internal let object: T
}

extension Retainer where T: Sendable {
    public func chain() -> T.SenderChain {
        return self.object.chain(retained: true)
    }
}

extension Retainer: ReceiveReferencable where T: ValueReceivable {
    public typealias ReceiveObject = T
    
    public func reference() -> Reference<ReceiveObject> {
        return .strong(self.object)
    }
}
