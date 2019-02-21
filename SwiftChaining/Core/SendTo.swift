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
    
    public func send0To<R: Receivable, T0, T1>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1), R.ReceiveValue == T0 {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value.0)
        }
    }
    
    public func send0To<R: Receivable, T0, T1, T2>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2), R.ReceiveValue == T0 {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value.0)
        }
    }
    
    public func send1To<R: Receivable, T0, T1>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1), R.ReceiveValue == T1 {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value.1)
        }
    }
    
    public func send1To<R: Receivable, T0, T1, T2>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2), R.ReceiveValue == T1 {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value.1)
        }
    }
    
    public func send2To<R: Receivable, T0, T1, T2>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2), R.ReceiveValue == T2 {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value.2)
        }
    }
}
