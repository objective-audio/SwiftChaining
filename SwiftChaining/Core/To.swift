//
//  To.swift
//

import Foundation

extension Chain {
    public typealias ToChain<Next> = Chain<Next, HandlerIn, Sender>
    
    public func to<Next>(_ transform: @escaping (HandlerOut) -> Next) -> ToChain<Next> {
        guard let joint = self.joint else {
            fatalError()
        }
        
        self.joint = nil
        
        let handler = self.handler
        
        return ToChain(joint: joint) { value in
            return transform(handler(value))
        }
    }
    
    public func toValue<Next>(_ value: Next) -> ToChain<Next> {
        return self.to { _ in value }
    }
    
    public func toVoid() -> Chain<Void, HandlerIn, Sender> {
        return self.to { _ in () }
    }
}
