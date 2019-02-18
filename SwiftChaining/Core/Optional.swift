//
//  Optional.swift
//

import Foundation

extension Chain {
    public func optional() -> Chain<Out?, HandlerIn, Sender> {
        return self.map { Optional($0) }
    }
    
    public func guardUnwrap<Unwrapped>() -> Chain<Unwrapped, Unwrapped?, Sender> where Out == Unwrapped? {
        return self.guard { (wrapped: Unwrapped?) in wrapped != nil }.forceUnwrap()
    }
    
    public func forceUnwrap<Unwrapped>() -> Chain<Unwrapped, HandlerIn, Sender> where Out == Unwrapped? {
        return self.map { (wrapped: Unwrapped?) in wrapped! }
    }
}
