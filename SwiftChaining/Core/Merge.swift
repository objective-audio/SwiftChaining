//
//  Merge.swift
//

import Foundation

extension Chain where Chainer: Fetchable {
    public func merge<Chainer1>(_ chain1: Chain<Out, Chainer1>) -> Chain<Out, Chainer> where Chainer1: Fetchable {
        return _merge(chain0: self, chain1: chain1)
    }
    
    public func merge<Chainer1>(_ chain1: Chain<Out, Chainer1>) -> Chain<Out, Chainer> {
        return _merge(chain0: self, chain1: chain1)
    }
}

extension Chain {
    public func merge<Chainer1>(_ chain1: Chain<Out, Chainer1>) -> Chain<Out, Chainer1> where Chainer1: Fetchable {
        return _merge(chain0: chain1, chain1: self)
    }
    
    public func merge<Chainer1>(_ chain1: Chain<Out, Chainer1>) -> Chain<Out, Chainer> {
        return _merge(chain0: self, chain1: chain1)
    }
}

private func _merge<Out0, Chainer0, Chainer1>(chain0: Chain<Out0, Chainer0>,
                                              chain1: Chain<Out0, Chainer1>) -> Chain<Out0, Chainer0> {
    guard let joint0 = chain0.pullJoint(), let joint1 = chain1.pullJoint() else {
        fatalError()
    }
    
    let nextIndex =  joint0.handlers.count + 1
    
    let handler1: JointHandler<Out0> = { [weak joint0] value, _ in
        if let joint0 = joint0, let nextHandler = joint0.handler(at: nextIndex) as? JointHandler<Out0> {
            nextHandler(value, joint0)
        }
    }
    
    joint1.appendHandler(handler1)
    
    let handler0: JointHandler<Out0> = { value, joint in
        if let nextHandler = joint.handlers[nextIndex] as? JointHandler<Out0> {
            nextHandler(value, joint)
        }
    }
    
    joint0.appendHandler(handler0)
    joint0.appendSubJoint(joint1)
    
    return Chain<Out0, Chainer0>(joint: joint0)
}
