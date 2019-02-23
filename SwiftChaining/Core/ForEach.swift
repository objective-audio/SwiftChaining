//
//  ForEach.swift
//

import Foundation

extension Chain where Out: Sequence {
    public typealias ForEachOut = Out.Element
    public typealias ForEachChain = Chain<ForEachOut, Sender>
    
    public func forEach() -> ForEachChain {
        guard let joint = self.pullJoint() else {
            fatalError()
        }
        
        let nextIndex = joint.handlers.count + 1
        
        let handler: JointHandler<Out> = { value, joint in
            if let nextHandler = joint.handlers[nextIndex] as? JointHandler<ForEachOut> {
                for element in value {
                    nextHandler(element, joint)
                }
            }
        }
        
        joint.handlers.append(handler)
        
        return ForEachChain(joint: joint)
    }
}
