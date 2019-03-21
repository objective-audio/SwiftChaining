//
//  Chainable.swift
//

import Foundation

public protocol Chainable: class {
    associatedtype ChainValue
    typealias BeginChain = Chain<ChainValue, Self>
    
    func fetch(for: JointClass)
}

extension Chainable {
    public func fetch(for: JointClass) {}
    
    public func retain() -> Retainer<Self> {
        return Retainer(object: self)
    }
    
    public func chain() -> BeginChain {
        return self.chain(retained: false)
    }
    
    internal func chain(retained: Bool) -> BeginChain {
        let core = CoreGlobal.getOrCreateCore(for: self)
        
        let chainer: Reference<Self> = retained ? .strong(self) : .weak(Weak(self))
        
        let joint = core.addJoint(chainer: chainer)
        
        let handler0: JointHandler<ChainValue> = { value, joint in
            if let nextHandler = joint.handler(at: 1) as? JointHandler<ChainValue> {
                nextHandler(value, joint)
            }
        }
        
        joint.appendHandler(handler0)
        
        return BeginChain(joint: joint)
    }
}
