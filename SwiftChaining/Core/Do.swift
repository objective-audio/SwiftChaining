//
//  Do.swift
//

import Foundation

extension Chain {
    public func `do`(_ doHandler: @escaping (Out) -> Void) -> Chain<Out, HandlerIn, Sender> {
        guard let joint = self.joint else {
            fatalError()
        }
        
        self.joint = nil
        
        let handler = self.handler
        
        return Chain<Out, HandlerIn, Sender>(joint: joint) { value in
            let result = handler(value)
            doHandler(result)
            return result
        }
    }
}
