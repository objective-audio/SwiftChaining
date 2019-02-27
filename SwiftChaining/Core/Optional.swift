//
//  Optional.swift
//

import Foundation

extension Chain {
    public func optional() -> Chain<Out?, Sender> {
        return self.map { Optional($0) }
    }
    
    public func unwrap<Unwrapped>() -> Chain<Unwrapped, Sender> where Out == Unwrapped? {
        return self.guard { (wrapped: Unwrapped?) in wrapped != nil }.forceUnwrap()
    }
    
    public func forceUnwrap<Unwrapped>() -> Chain<Unwrapped, Sender> where Out == Unwrapped? {
        return self.map { (wrapped: Unwrapped?) in wrapped! }
    }
}
