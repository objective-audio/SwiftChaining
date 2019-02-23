//
//  Guard.swift
//

import Foundation

extension Chain {
    public typealias GuardChain = Chain<Out, Sender>
    
    public func `guard`(_ isIncluded: @escaping (Out) -> Bool) -> GuardChain {
        guard let joint = self.pullJoint() else {
            fatalError()
        }
        
        let nextIndex = joint.handlerCount + 1
        
        let guardHandler: JointHandler<Out> = { value, joint in
            guard isIncluded(value) else {
                return
            }
            
            if let nextHandler = joint.handler(at: nextIndex) as? JointHandler<Out> {
                nextHandler(value, joint)
            }
        }
        
        joint.appendHandler(guardHandler)
        
        return GuardChain(joint: joint)
    }
}

extension Chain {
    public typealias FilterChain = GuardChain
    
    public func filter(_ isIncluded: @escaping (Out) -> Bool) -> FilterChain {
        return self.guard(isIncluded)
    }
}
