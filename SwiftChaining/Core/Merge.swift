//
//  Merge.swift
//

import Foundation

extension Chain where Sender: Fetchable {
    public func merge<Sender1>(_ chain1: Chain<Out, Sender1>) -> Chain<Out, Sender> where Sender1: Fetchable {
        return _merge2(chain0: self, chain1: chain1)
    }
    
    public func merge<Sender1>(_ chain1: Chain<Out, Sender1>) -> Chain<Out, Sender> {
        return _merge2(chain0: self, chain1: chain1)
    }
}

extension Chain {
    public func merge<Sender1>(_ chain1: Chain<Out, Sender1>) -> Chain<Out, Sender1> where Sender1: Fetchable {
        return _merge2(chain0: chain1, chain1: self)
    }
    
    public func merge<Sender1>(_ chain1: Chain<Out, Sender1>) -> Chain<Out, Sender> {
        return _merge2(chain0: self, chain1: chain1)
    }
}

private func _merge2<Out0, Sender0, Sender1>(chain0: Chain<Out0, Sender0>,
                                             chain1: Chain<Out0, Sender1>) -> Chain<Out0, Sender0> {
    guard let joint0 = chain0.joint, let joint1 = chain1.joint else {
        fatalError()
    }
    
    chain0.joint = nil
    chain1.joint = nil
    
    let nextIndex =  joint0.handlers.count + 1
    
    let handler1: JointHandler<Out0> = { [weak joint0] value, _ in
        if let joint0 = joint0, let nextHandler = joint0.handlers[nextIndex] as? JointHandler<Out0> {
            nextHandler(value, joint0)
        }
    }
    
    joint1.handlers.append(handler1)
    
    let handler0: JointHandler<Out0> = { value, joint in
        if let nextHandler = joint.handlers[nextIndex] as? JointHandler<Out0> {
            nextHandler(value, joint)
        }
    }
    
    joint0.handlers.append(handler0)
    
    joint0.subJoints.append(joint1)
    
    return Chain<Out0, Sender0>(joint: joint0)
}

