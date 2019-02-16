//
//  To.swift
//

import Foundation

extension Chain {
    public typealias MapChain<Next> = Chain<Next, HandlerIn, Sender>
    
    public func map<Next>(_ transform: @escaping (HandlerOut) -> Next) -> MapChain<Next> {
        guard let joint = self.joint else {
            fatalError()
        }
        
        self.joint = nil
        
        let handler = self.handler
        
        return MapChain(joint: joint) { value in
            return transform(handler(value))
        }
    }
    
    public func replace<Next>(_ value: Next) -> MapChain<Next> {
        return self.map { _ in value }
    }
    
    public func replaceWithVoid() -> Chain<Void, HandlerIn, Sender> {
        return self.map { _ in () }
    }
}