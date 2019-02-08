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
    
    public func receive<Root: AnyObject>(_ receiver: Root, keyPath: ReferenceWritableKeyPath<Root, HandlerOut>) -> Chain<HandlerOut, HandlerIn, Sender> {
        return self.do { [weak receiver] value in
            receiver?[keyPath: keyPath] = value
        }
    }
}
