//
//  Do.swift
//

import Foundation

extension Chain {
    public func `do`(_ doHandler: @escaping (HandlerOut) -> Void) -> Chain<HandlerOut, HandlerIn, Sender> {
        guard let joint = self.joint else {
            fatalError()
        }
        
        self.joint = nil
        
        let handler = self.handler
        
        return Chain<HandlerOut, HandlerIn, Sender>(joint: joint) { value in
            let result = handler(value)
            doHandler(result)
            return result
        }
    }
}
