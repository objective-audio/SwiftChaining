//
//  Merge.swift
//

import Foundation

extension Chain where ChainType: FetchableProtocol {
    public func merge<Chainer1>(_ chain1: Chain<Out, Chainer1>) -> Chain<Out, ChainType> where Chainer1: FetchableProtocol {
        return _merge(chain0: self, chain1: chain1)
    }
    
    public func merge<Chainer1>(_ chain1: Chain<Out, Chainer1>) -> Chain<Out, ChainType> {
        return _merge(chain0: self, chain1: chain1)
    }
}

extension Chain {
    public func merge<ChainType1>(_ chain1: Chain<Out, ChainType1>) -> Chain<Out, ChainType1> where ChainType1: FetchableProtocol {
        return _merge(chain0: chain1, chain1: self)
    }
    
    public func merge<ChainType1>(_ chain1: Chain<Out, ChainType1>) -> Chain<Out, ChainType> {
        return _merge(chain0: self, chain1: chain1)
    }
}

private func _merge<Out0, ChainType0, ChainType1>(chain0: Chain<Out0, ChainType0>,
                                                  chain1: Chain<Out0, ChainType1>) -> Chain<Out0, ChainType0> {
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
    
    return Chain<Out0, ChainType0>(joint: joint0)
}
