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
    
    public func send0To<R: Receivable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2, T3), R.ReceiveValue == T0 {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value.0)
        }
    }
    
    public func send0To<R: Receivable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2, T3, T4), R.ReceiveValue == T0 {
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
    
    public func send1To<R: Receivable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2, T3), R.ReceiveValue == T1 {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value.1)
        }
    }
    
    public func send1To<R: Receivable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2, T3, T4), R.ReceiveValue == T1 {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value.1)
        }
    }
    
    public func send2To<R: Receivable, T0, T1, T2>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2), R.ReceiveValue == T2 {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value.2)
        }
    }
    
    public func send2To<R: Receivable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2, T3), R.ReceiveValue == T2 {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value.2)
        }
    }
    
    public func send2To<R: Receivable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2, T3, T4), R.ReceiveValue == T2 {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value.2)
        }
    }
    
    public func send3To<R: Receivable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2, T3), R.ReceiveValue == T3 {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value.3)
        }
    }
    
    public func send3To<R: Receivable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2, T3, T4), R.ReceiveValue == T3 {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value.3)
        }
    }
    
    public func send4To<R: Receivable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2, T3, T4), R.ReceiveValue == T4 {
        return self.do { [weak receiver] value in
            receiver?.receive(value: value.4)
        }
    }
    
    public func sendTo<R: Receivable, T>(_ receiver: R) -> Chain<Out, In, Sender> where Out == T?, R.ReceiveValue == T {
        return self.do { [weak receiver] value in
            if let value = value {
                receiver?.receive(value: value)
            }
        }
    }
    
    public func send0To<R: Receivable, T0, T1>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0?, T1), R.ReceiveValue == T0 {
        return self.do { [weak receiver] value in
            if let value = value.0 {
                receiver?.receive(value: value)
            }
        }
    }
    
    public func send0To<R: Receivable, T0, T1, T2>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0?, T1, T2), R.ReceiveValue == T0 {
        return self.do { [weak receiver] value in
            if let value = value.0 {
                receiver?.receive(value: value)
            }
        }
    }
    
    public func send0To<R: Receivable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0?, T1, T2, T3), R.ReceiveValue == T0 {
        return self.do { [weak receiver] value in
            if let value = value.0 {
                receiver?.receive(value: value)
            }
        }
    }
    
    public func send0To<R: Receivable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0?, T1, T2, T3, T4), R.ReceiveValue == T0 {
        return self.do { [weak receiver] value in
            if let value = value.0 {
                receiver?.receive(value: value)
            }
        }
    }
    
    public func send1To<R: Receivable, T0, T1>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1?), R.ReceiveValue == T1 {
        return self.do { [weak receiver] value in
            if let value = value.1 {
                receiver?.receive(value: value)
            }
        }
    }
    
    public func send1To<R: Receivable, T0, T1, T2>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1?, T2), R.ReceiveValue == T1 {
        return self.do { [weak receiver] value in
            if let value = value.1 {
                receiver?.receive(value: value)
            }
        }
    }
    
    public func send1To<R: Receivable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1?, T2, T3), R.ReceiveValue == T1 {
        return self.do { [weak receiver] value in
            if let value = value.1 {
                receiver?.receive(value: value)
            }
        }
    }
    
    public func send1To<R: Receivable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1?, T2, T3, T4), R.ReceiveValue == T1 {
        return self.do { [weak receiver] value in
            if let value = value.1 {
                receiver?.receive(value: value)
            }
        }
    }
    
    public func send2To<R: Receivable, T0, T1, T2>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2?), R.ReceiveValue == T2 {
        return self.do { [weak receiver] value in
            if let value = value.2 {
                receiver?.receive(value: value)
            }
        }
    }
    
    public func send2To<R: Receivable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2?, T3), R.ReceiveValue == T2 {
        return self.do { [weak receiver] value in
            if let value = value.2 {
                receiver?.receive(value: value)
            }
        }
    }
    
    public func send2To<R: Receivable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2?, T3, T4), R.ReceiveValue == T2 {
        return self.do { [weak receiver] value in
            if let value = value.2 {
                receiver?.receive(value: value)
            }
        }
    }
    
    public func send3To<R: Receivable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2, T3?), R.ReceiveValue == T3 {
        return self.do { [weak receiver] value in
            if let value = value.3 {
                receiver?.receive(value: value)
            }
        }
    }
    
    public func send3To<R: Receivable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2, T3?, T4), R.ReceiveValue == T3 {
        return self.do { [weak receiver] value in
            if let value = value.3 {
                receiver?.receive(value: value)
            }
        }
    }
    
    public func send4To<R: Receivable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, In, Sender> where Out == (T0, T1, T2, T3, T4?), R.ReceiveValue == T4 {
        return self.do { [weak receiver] value in
            if let value = value.4 {
                receiver?.receive(value: value)
            }
        }
    }
}
