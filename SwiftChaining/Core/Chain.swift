//
//  Chain.swift
//

import Foundation

final public class Chain<Out, Chainer: Chainable> {
    private var joint: Joint<Chainer>?
    
    internal init(joint: Joint<Chainer>) {
        precondition(joint.chainer != nil, "Chainer must be retained while chaining.")
        
        self.joint = joint
    }
    
    internal func pullJoint() -> Joint<Chainer>? {
        defer { self.joint = nil }
        return self.joint
    }
}
