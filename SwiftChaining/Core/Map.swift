//
//  To.swift
//

import Foundation

extension Chain {
    public typealias MapChain<Next> = Chain<Next, Sender>
    
    public func map<Next>(_ transform: @escaping (Out) -> Next) -> MapChain<Next> {
        guard let joint = self.pullJoint() else {
            fatalError()
        }
        
        let nextIndex = joint.handlers.count + 1
        
        let handler: JointHandler<Out> = { value, joint in
            if let nextHandler = joint.handlers[nextIndex] as? JointHandler<Next> {
                nextHandler(transform(value), joint)
            }
        }
        
        joint.handlers.append(handler)
        
        return MapChain(joint: joint)
    }
    
    public func replace<Next>(_ value: Next) -> MapChain<Next> {
        return self.map { _ in value }
    }
    
    public func replaceWithVoid() -> Chain<Void, Sender> {
        return self.map { _ in () }
    }
}
