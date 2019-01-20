//
//  Chain.swift
//

import Foundation

final public class Chain<HandlerOut, HandlerIn, Sender: Sendable> {
    typealias Handler = (HandlerIn) -> HandlerOut
    
    internal var joint: Joint<Sender>?
    internal let handler: Handler
    
    internal init(joint: Joint<Sender>, handler: @escaping (HandlerIn) -> HandlerOut) {
        self.joint = joint
        self.handler = handler
    }
}
