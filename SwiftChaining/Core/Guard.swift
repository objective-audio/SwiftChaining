//
//  Guard.swift
//

import Foundation

extension Chain {
    public typealias GuardChain = Chain<Out, Out, Sender>
    
    public func `guard`(_ isIncluded: @escaping (Out) -> Bool) -> GuardChain {
        guard let joint = self.joint else {
            fatalError()
        }
        
        self.joint = nil
        
        let handler = self.handler
        let nextIndex = joint.handlers.count + 1
        
        let guardHandler: (HandlerIn) -> Void = { [weak joint] value in
            let result = handler(value)
            
            guard isIncluded(result) else {
                return
            }
            
            if let nextHandler = joint?.handlers[nextIndex] as? (Out) -> Void {
                nextHandler(result)
            }
        }
        
        joint.handlers.append(guardHandler)
        
        return GuardChain(joint: joint) { $0 }
    }
    
    public typealias FilterChain = GuardChain
    
    public func filter(_ isIncluded: @escaping (Out) -> Bool) -> FilterChain {
        return self.guard(isIncluded)
    }
}
