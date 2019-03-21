//
//  Do.swift
//

import Foundation

extension Chain {
    public typealias DoChain = Chain<Out, Chainer>
    
    public func `do`(_ doHandler: @escaping (Out) -> Void) -> Chain<Out, Chainer> {
        guard let joint = self.pullJoint() else {
            fatalError()
        }
        
        let nextIndex = joint.handlerCount + 1
        
        let handler: JointHandler<Out> = { value, joint in
            doHandler(value)
            if let nextHandler = joint.handler(at: nextIndex) as? JointHandler<Out> {
                nextHandler(value, joint)
            }
        }
        
        joint.appendHandler(handler)
        
        return DoChain(joint: joint)
    }
}

