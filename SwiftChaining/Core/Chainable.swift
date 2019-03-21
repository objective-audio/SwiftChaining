//
//  Chainable.swift
//

import Foundation

public protocol Chainable: class {
    associatedtype ChainValue
    typealias SenderChain = Chain<ChainValue, Self>
    
    func fetch(for: JointClass)
}

extension Chainable {
    public func fetch(for: JointClass) {}
    
    public func retain() -> Retainer<Self> {
        return Retainer(object: self)
    }
    
    public func chain() -> SenderChain {
        return self.chain(retained: false)
    }
    
    internal func chain(retained: Bool) -> SenderChain {
        let core = CoreGlobal.getOrCreateCore(for: self)
        
        let sender: Reference<Self> = retained ? .strong(self) : .weak(Weak(self))
        
        let joint = core.addJoint(sender: sender)
        
        let handler0: JointHandler<ChainValue> = { value, joint in
            if let nextHandler = joint.handler(at: 1) as? JointHandler<ChainValue> {
                nextHandler(value, joint)
            }
        }
        
        joint.appendHandler(handler0)
        
        return SenderChain(joint: joint)
    }
}