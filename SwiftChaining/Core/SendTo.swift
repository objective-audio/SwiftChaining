//
//  Receive.swift
//

import Foundation

extension Chain {
    public typealias SendToChain = Chain<Out, Chainer>
    
    public func sendTo<R: ReceiveReferencable>(_ receiver: R) -> Chain<Out, Chainer> where R.ReceiveObject.ReceiveValue == Out {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value)
        })
    }
    
    public func sendTo<R: ReceiveReferencable>(_ receiver: R) -> Chain<Out, Chainer> where R.ReceiveObject.ReceiveValue == Out? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value)
        })
    }
    
    public func sendTo<R: ReceiveReferencable, T>(_ receiver: R) -> Chain<Out, Chainer> where Out == T?, R.ReceiveObject.ReceiveValue == T {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1), R.ReceiveObject.ReceiveValue == T0 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.0)
        })
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2), R.ReceiveObject.ReceiveValue == T0 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.0)
        })
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T0 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.0)
        })
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T0 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.0)
        })
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1), R.ReceiveObject.ReceiveValue == T1 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.1)
        })
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2), R.ReceiveObject.ReceiveValue == T1 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.1)
        })
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T1 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.1)
        })
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T1 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.1)
        })
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2), R.ReceiveObject.ReceiveValue == T2 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.2)
        })
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T2 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.2)
        })
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T2 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.2)
        })
    }
    
    public func send3To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T3 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.3)
        })
    }
    
    public func send3To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T3 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.3)
        })
    }
    
    public func send4To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T4 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.4)
        })
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0?, T1), R.ReceiveObject.ReceiveValue == T0 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value.0 {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0?, T1, T2), R.ReceiveObject.ReceiveValue == T0 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value.0 {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0?, T1, T2, T3), R.ReceiveObject.ReceiveValue == T0 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value.0 {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0?, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T0 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value.0 {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1?), R.ReceiveObject.ReceiveValue == T1 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value.1 {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1?, T2), R.ReceiveObject.ReceiveValue == T1 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value.1 {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1?, T2, T3), R.ReceiveObject.ReceiveValue == T1 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value.1 {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1?, T2, T3, T4), R.ReceiveObject.ReceiveValue == T1 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value.1 {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2?), R.ReceiveObject.ReceiveValue == T2 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value.2 {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2?, T3), R.ReceiveObject.ReceiveValue == T2 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value.2 {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2?, T3, T4), R.ReceiveObject.ReceiveValue == T2 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value.2 {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send3To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3?), R.ReceiveObject.ReceiveValue == T3 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value.3 {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send3To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3?, T4), R.ReceiveObject.ReceiveValue == T3 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value.3 {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send4To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4?), R.ReceiveObject.ReceiveValue == T4 {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            if let value = value.4 {
                reference.value?.receive(value: value)
            }
        })
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1), R.ReceiveObject.ReceiveValue == T0? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.0)
        })
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2), R.ReceiveObject.ReceiveValue == T0? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.0)
        })
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T0? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.0)
        })
    }
    
    public func send0To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T0? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.0)
        })
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1), R.ReceiveObject.ReceiveValue == T1? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.1)
        })
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2), R.ReceiveObject.ReceiveValue == T1? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.1)
        })
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T1? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.1)
        })
    }
    
    public func send1To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T1? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.1)
        })
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2), R.ReceiveObject.ReceiveValue == T2? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.2)
        })
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T2? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.2)
        })
    }
    
    public func send2To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T2? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.2)
        })
    }
    
    public func send3To<R: ReceiveReferencable, T0, T1, T2, T3>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3), R.ReceiveObject.ReceiveValue == T3? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.3)
        })
    }
    
    public func send3To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T3? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.3)
        })
    }
    
    public func send4To<R: ReceiveReferencable, T0, T1, T2, T3, T4>(_ receiver: R) -> Chain<Out, Chainer> where Out == (T0, T1, T2, T3, T4), R.ReceiveObject.ReceiveValue == T4? {
        return self._sendTo(receiver, sendToHandler: { reference, value in
            reference.value?.receive(value: value.4)
        })
    }
    
    private func _sendTo<R: ReceiveReferencable>(_ receiver: R, sendToHandler: @escaping (Reference<R.ReceiveObject>, Out) -> Void) -> Chain<Out, Chainer> {
        guard let joint = self.pullJoint() else {
            fatalError()
        }
        
        let nextIndex = joint.handlers.count + 1
        
        let reference = receiver.reference()
        joint.references.append(reference)
        
        let handler: JointHandler<Out> = { value, joint in
            sendToHandler(reference, value)
            if let nextHandler = joint.handlers[nextIndex] as? JointHandler<Out> {
                nextHandler(value, joint)
            }
        }
        
        joint.appendHandler(handler)
        
        return SendToChain(joint: joint)
    }
}

