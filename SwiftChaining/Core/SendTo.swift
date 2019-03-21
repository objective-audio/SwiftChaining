//
//  Receive.swift
//

import Foundation

extension Chain {
    public func sendTo<R: ReceiveReferencable>(_ receiver: R) -> Chain<Out, Chainer> where R.ReceiveObject.ReceiveValue == Out {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value)
        }
    }
    
    public func sendTo<R: ReceiveReferencable>(_ receiver: R) -> Chain<Out, Chainer> where R.ReceiveObject.ReceiveValue == Out? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value)
        }
    }
    
    public func sendTo<R: ReceiveReferencable, T>(_ receiver: R) -> Chain<Out, Chainer> where Out == T?, R.ReceiveObject.ReceiveValue == T {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1), R.ReceiveObject.ReceiveValue == T0 {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.0)
        }
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2), R.ReceiveObject.ReceiveValue == T0 {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.0)
        }
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T0 {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.0)
        }
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T0 {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.0)
        }
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1), R.ReceiveObject.ReceiveValue == T1 {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.1)
        }
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2), R.ReceiveObject.ReceiveValue == T1 {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.1)
        }
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T1 {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.1)
        }
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T1 {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.1)
        }
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2), R.ReceiveObject.ReceiveValue == T2 {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.2)
        }
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T2 {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.2)
        }
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T2 {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.2)
        }
    }
    
    public func send3To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T3 {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.3)
        }
    }
    
    public func send3To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T3 {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.3)
        }
    }
    
    public func send4To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T4 {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.4)
        }
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0?, T1), R.ReceiveObject.ReceiveValue == T0 {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value.0 {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0?, T1, T2), R.ReceiveObject.ReceiveValue == T0 {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value.0 {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0?, T1, T2, T3), R.ReceiveObject.ReceiveValue == T0 {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value.0 {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0?, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T0 {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value.0 {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1?), R.ReceiveObject.ReceiveValue == T1 {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value.1 {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1?, T2), R.ReceiveObject.ReceiveValue == T1 {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value.1 {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1?, T2, T3), R.ReceiveObject.ReceiveValue == T1 {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value.1 {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1?, T2, T3, T4), R.ReceiveObject.ReceiveValue == T1 {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value.1 {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2?), R.ReceiveObject.ReceiveValue == T2 {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value.2 {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2?, T3), R.ReceiveObject.ReceiveValue == T2 {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value.2 {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2?, T3, T4), R.ReceiveObject.ReceiveValue == T2 {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value.2 {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send3To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3?), R.ReceiveObject.ReceiveValue == T3 {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value.3 {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send3To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3?, T4), R.ReceiveObject.ReceiveValue == T3 {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value.3 {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send4To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4?), R.ReceiveObject.ReceiveValue == T4 {
        let reference = receiver.reference()
        return self.do { value in
            if let value = value.4 {
                reference.value?.receive(value: value)
            }
        }
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1), R.ReceiveObject.ReceiveValue == T0? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.0)
        }
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2), R.ReceiveObject.ReceiveValue == T0? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.0)
        }
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T0? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.0)
        }
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T0? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.0)
        }
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1), R.ReceiveObject.ReceiveValue == T1? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.1)
        }
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2), R.ReceiveObject.ReceiveValue == T1? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.1)
        }
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T1? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.1)
        }
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T1? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.1)
        }
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2), R.ReceiveObject.ReceiveValue == T2? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.2)
        }
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T2? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.2)
        }
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T2? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.2)
        }
    }
    
    public func send3To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T3? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.3)
        }
    }
    
    public func send3To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T3? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.3)
        }
    }
    
    public func send4To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T4? {
        let reference = receiver.reference()
        return self.do { value in
            reference.value?.receive(value: value.4)
        }
    }
}

