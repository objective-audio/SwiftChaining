//
//  Do.swift
//

import Foundation

extension Chain {
    public typealias DoChain = Chain<Out, ChainType>
    
    public func `do`(_ doHandler: @escaping (Out) -> Void) -> Chain<Out, ChainType> {
        guard let joint = self.pullJoint() else {
            fatalError()
        }
        
        let nextIndex = joint.handlers.count + 1
        
        let handler: JointHandler<Out> = { value, joint in
            doHandler(value)
            if nextIndex < joint.handlers.count,
                let nextHandler = joint.handlers[nextIndex] as? JointHandler<Out> {
                nextHandler(value, joint)
            }
        }
        
        joint.appendHandler(handler)
        
        return DoChain(joint: joint)
    }
}
