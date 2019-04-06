//
//  Each.swift
//

import Foundation

extension Chain where Out: Sequence {
    public typealias EachOut = Out.Element
    public typealias EachChain = Chain<EachOut, ChainType>
    
    public func each() -> EachChain {
        guard let joint = self.pullJoint() else {
            fatalError()
        }
        
        let nextIndex = joint.handlers.count + 1
        
        let handler: JointHandler<Out> = { value, joint in
            if let nextHandler = joint.handlers[nextIndex] as? JointHandler<EachOut> {
                for element in value {
                    nextHandler(element, joint)
                }
            }
        }
        
        joint.appendHandler(handler)
        
        return EachChain(joint: joint)
    }
}
