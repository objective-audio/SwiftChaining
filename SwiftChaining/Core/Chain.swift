//
//  Chain.swift
//

import Foundation

final public class Chain<Out, Sender: Sendable> {
    private var joint: Joint<Sender>?
    
    internal init(joint: Joint<Sender>) {
        self.joint = joint
    }
    
    internal func pullJoint() -> Joint<Sender>? {
        defer { self.joint = nil }
        return self.joint
    }
}
