//
//  ForEach.swift
//

import Foundation

extension Chain where Out: Sequence {
    public typealias ForEachOut = Out.Element
    public typealias ForEachChain = Chain<ForEachOut, Chainer>
    
    public func forEach() -> ForEachChain {
        guard let joint = self.pullJoint() else {
            fatalError()
        }
        
        let nextIndex = joint.handlerCount + 1
        
        let handler: JointHandler<Out> = { value, joint in
            if let nextHandler = joint.handler(at: nextIndex) as? JointHandler<ForEachOut> {
                for element in value {
                    nextHandler(element, joint)
                }
            }
        }
        
        joint.appendHandler(handler)
        
        return ForEachChain(joint: joint)
    }
}
