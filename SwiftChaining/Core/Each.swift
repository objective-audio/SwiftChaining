//
//  Each.swift
//

import Foundation

extension Chain where Out: Sequence {
    public typealias EachOut = Out.Element
    public typealias EachChain = Chain<EachOut, Chainer>
    
    public func each() -> EachChain {
        guard let joint = self.pullJoint() else {
            fatalError()
        }
        
        let nextIndex = joint.handlerCount + 1
        
        let handler: JointHandler<Out> = { value, joint in
            if let nextHandler = joint.handler(at: nextIndex) as? JointHandler<EachOut> {
                for element in value {
                    nextHandler(element, joint)
                }
            }
        }
        
        joint.appendHandler(handler)
        
        return EachChain(joint: joint)
    }
}
