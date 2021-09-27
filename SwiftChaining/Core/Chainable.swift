//
//  Chainable.swift
//

import Foundation

public protocol Chainable: AnyObject {
    associatedtype ChainValue
    typealias FirstChain = Chain<ChainValue, Self>
    
    func fetch(for: JointClass)
}

extension Chainable {
    public func fetch(for: JointClass) {}
    
    public func retain() -> Retainer<Self> {
        return Retainer(object: self)
    }
    
    public func chain() -> FirstChain {
        return CoreGlobal.makeChain(chainer: self, retained: false)
    }
}
