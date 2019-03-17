//
//  Chain.swift
//

import Foundation

final public class Chain<Out, Sender: Sendable> {
    private var joint: Joint<Sender>?
    
    internal init(joint: Joint<Sender>) {
        precondition(joint.sender != nil, "Sender must be retained while chaining.")
        
        self.joint = joint
    }
    
    internal func pullJoint() -> Joint<Sender>? {
        defer { self.joint = nil }
        return self.joint
    }
}
