//
//  Do.swift
//

import Foundation

extension Chain {
    public func `do`(_ doHandler: @escaping (Out) -> Void) -> Chain<Out, Sender> {
        guard let joint = self.joint else {
            fatalError()
        }
        
        self.joint = nil
        
        let nextIndex = joint.handlers.count + 1
        
        let handler: JointHandler<Out> = { value, joint in
            doHandler(value)
            if let nextHandler = joint.handlers[nextIndex] as? JointHandler<Out> {
                nextHandler(value, joint)
            }
        }
        
        joint.handlers.append(handler)
        
        return Chain(joint: joint)
    }
}

