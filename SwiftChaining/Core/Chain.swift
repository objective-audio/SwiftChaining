//
//  Chain.swift
//

import Foundation

final public class Chain<Out, In, Sender: Sendable> {
    typealias Handler = (In) -> Out
    
    internal var joint: Joint<Sender>?
    internal let handler: Handler
    
    internal init(joint: Joint<Sender>, handler: @escaping (In) -> Out) {
        self.joint = joint
        self.handler = handler
    }
}
