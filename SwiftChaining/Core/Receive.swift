//
//  Receive.swift
//

import Foundation

extension Chain {
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
