//
//  Chain.swift
//

import Foundation

public class Chain<HandlerOut, HandlerIn, Sender: Sendable> {
    typealias Handler = (HandlerIn) -> HandlerOut
    
    var joint: Joint<Sender>?
    let handler: Handler
    
    init(joint: Joint<Sender>, handler: @escaping (HandlerIn) -> HandlerOut) {
        self.joint = joint
        self.handler = handler
    }
}
