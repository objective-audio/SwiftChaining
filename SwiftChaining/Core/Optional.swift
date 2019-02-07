//
//  Optional.swift
//

import Foundation

extension Chain {
    public func optional() -> Chain<HandlerOut?, HandlerIn, Sender> {
        return self.to { Optional($0) }
    }
    
    public func guardUnwrap<Unwrapped>() -> Chain<Unwrapped, Unwrapped?, Sender> where HandlerOut == Unwrapped? {
        return self.guard { (wrapped: Unwrapped?) in wrapped != nil }.forceUnwrap()
    }
    
    public func forceUnwrap<Unwrapped>() -> Chain<Unwrapped, HandlerIn, Sender> where HandlerOut == Unwrapped? {
        return self.to { (wrapped: Unwrapped?) in wrapped! }
    }
}
