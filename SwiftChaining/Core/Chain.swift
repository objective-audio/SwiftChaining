//
//  Chain.swift
//

import Foundation

final public class Chain<Out, HandlerIn, Sender: Sendable> {
    typealias Handler = (HandlerIn) -> Out
    
    internal var joint: Joint<Sender>?
    internal let handler: Handler
    
    internal init(joint: Joint<Sender>, handler: @escaping (HandlerIn) -> Out) {
        self.joint = joint
        self.handler = handler
    }
}
