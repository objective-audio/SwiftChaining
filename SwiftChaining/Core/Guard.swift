//
//  Guard.swift
//

import Foundation

extension Chain {
    public typealias GuardChain = Chain<Out, ChainType>
    
    public func `guard`(_ isIncluded: @escaping (Out) -> Bool) -> GuardChain {
        guard let joint = self.pullJoint() else {
            fatalError()
        }
        
        let nextIndex = joint.handlers.count + 1
        
        let guardHandler: JointHandler<Out> = { value, joint in
            guard isIncluded(value) else {
                return
            }
            
            if let nextHandler = joint.handlers[nextIndex] as? JointHandler<Out> {
                nextHandler(value, joint)
            }
        }
        
        joint.appendHandler(guardHandler)
        
        return GuardChain(joint: joint)
    }
}

extension Chain where Out: Equatable {
    public func guardIfEqual() -> GuardChain {
        var cache: Out? = nil
        return self.guard { value in
            defer { cache = value }
            if let cache = cache {
                return cache != value
            } else {
                return true
            }
        }
    }
}

extension Chain {
    public typealias FilterChain = GuardChain
    
    public func filter(_ isIncluded: @escaping (Out) -> Bool) -> FilterChain {
        return self.guard(isIncluded)
    }
}
