//
//  Retainer.swift
//

import Foundation

public struct Retainer<T> {
    internal let object: T
}

extension Retainer where T: Chainable {
   public func chain() -> FirstChain<T.ChainType> {
        return CoreGlobal.makeChain(chainer: self.object, retained: true)
    }
}

extension Retainer: ReceiveReferencable where T: ValueReceivable {
    public typealias ReceiveObject = T
    
    public func reference() -> Reference<ReceiveObject> {
        return .strong(self.object)
    }
}
