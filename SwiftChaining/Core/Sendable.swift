//
//  Sendable.swift
//

import Foundation

public protocol Sendable: class {
    associatedtype SendValue
    typealias SenderChain = Chain<SendValue, Self>
    
    func fetch(for: JointClass)
}

public struct Retainer<T> {
    internal let object: T
}

extension Retainer where T: Sendable {
    public func chain() -> T.SenderChain {
        return object.chain(retained: true)
    }
}

extension Sendable {
    public func fetch(for: JointClass) {}
    
    public func broadcast(value: SendValue) {
        self.getCore()?.broadcast(value: value)
    }
    
    public func retain() -> Retainer<Self> {
        return Retainer(object: self)
    }
    
    public func chain() -> SenderChain {
        return self.chain(retained: false)
    }
    
    fileprivate func chain(retained: Bool) -> SenderChain {
        let core = self.getOrCreateCore()
        let joint = core.addJoint(sender: self)
        
        if retained {
            joint.strongSender = self
        }
        
        let handler0: JointHandler<SendValue> = { value, joint in
            if let nextHandler = joint.handler(at: 1) as? JointHandler<SendValue> {
                nextHandler(value, joint)
            }
        }
        
        joint.appendHandler(handler0)
        
        return SenderChain(joint: joint)
    }
    
    fileprivate func getOrCreateCore() -> SenderCore<Self> {
        let id = ObjectIdentifier(self)
        
        if let core = CoreGlobal.shared.core(for: id) as SenderCore<Self>? {
            return core
        } else {
            let core = SenderCore<Self>(removeId: id)
            CoreGlobal.shared.set(core: core, for: id)
            return core
        }
    }
    
    internal func getCore() -> SenderCore<Self>? {
        return CoreGlobal.shared.core(for: ObjectIdentifier(self)) as SenderCore<Self>?
    }
}
