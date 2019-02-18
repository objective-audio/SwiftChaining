//
//  Receive.swift
//

import Foundation

extension Chain {
    public func sendTo<R: Receivable>(_ receiver: R) -> Chain<Out, In, Sender> where R.ReceiveValue == Out {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value)
        }
    }
    
    public func sendTo<Root: AnyObject>(_ receiver: Root, keyPath: ReferenceWritableKeyPath<Root, Out>) -> Chain<Out, In, Sender> {
        return self.do { [weak receiver] value in
            receiver?[keyPath: keyPath] = value
        }
    }
}
