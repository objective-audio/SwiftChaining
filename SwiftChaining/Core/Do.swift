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
    
    public func receive<R: Receivable>(_ receiver: R) -> Chain<HandlerOut, HandlerIn, Sender> where R.ReceiveValue == HandlerOut {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value)
        }
    }
    
    public func receive<R: Receivable>(_ receiver: R) -> Chain<HandlerOut, HandlerIn, Sender> where R.ReceiveValue == HandlerOut? {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value)
        }
    }
    
    public func receive<R: Receivable>(_ receiver: R) -> Chain<HandlerOut, HandlerIn, Sender> where R.ReceiveValue == Void {
        return self.do { [weak receiver] _ in
            receiver?.receive(value: ())
        }
    }
}
