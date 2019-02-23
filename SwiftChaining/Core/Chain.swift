//
//  Chain.swift
//

import Foundation

final public class Chain<Out, Sender: Sendable> {
    internal var joint: Joint<Sender>?
    
    internal init(joint: Joint<Sender>) {
        self.joint = joint
    }
}
