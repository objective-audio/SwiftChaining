//
//  Merge.swift
//

import Foundation

extension Chain where Sender: Fetchable {
    public func merge<In1, Sender1>(_ chain1: Chain<Out, In1, Sender1>) -> Chain<Out, Out, Sender> where Sender1: Fetchable {
        return _merge(chain0: self, chain1: chain1)
    }
    
    public func merge<In1, Sender1>(_ chain1: Chain<Out, In1, Sender1>) -> Chain<Out, Out, Sender> {
        return _merge(chain0: self, chain1: chain1)
    }
}

extension Chain {
    public func merge<In1, Sender1>(_ chain1: Chain<Out, In1, Sender1>) -> Chain<Out, Out, Sender1> where Sender1: Fetchable {
        return _merge(chain0: chain1, chain1: self)
    }
    
    public func merge<In1, Sender1>(_ chain1: Chain<Out, In1, Sender1>) -> Chain<Out, Out, Sender> {
        return _merge(chain0: self, chain1: chain1)
    }
}

private func _merge<Out0, In0, Sender0, In1, Sender1>(chain0: Chain<Out0, In0, Sender0>,
                                                      chain1: Chain<Out0, In1, Sender1>) -> Chain<Out0, Out0, Sender0> {
    guard let joint0 = chain0.joint, let joint1 = chain1.joint else {
        fatalError()
    }
    
    chain0.joint = nil
    chain1.joint = nil
    
    let handler0 = chain0.handler
    let handler1 = chain1.handler
    let nextIndex =  joint0.handlers.count + 1
    
    let newHandler1: (In1) -> Void = { [weak joint0] value in
        if let joint0 = joint0, let nextHandler = joint0.handlers[nextIndex] as? (Out0) -> Void {
            nextHandler(handler1(value))
        }
    }
    
    joint1.handlers.append(newHandler1)
    
    let newHandler0: (In0) -> Void = { [weak joint0] value in
        if let joint0 = joint0, let nextHandler = joint0.handlers[nextIndex] as? (Out0) -> Void {
            nextHandler(handler0(value))
        }
    }
    
    joint0.handlers.append(newHandler0)
    
    joint0.subJoints.append(joint1)
    
    return Chain<Out0, Out0, Sender0>(joint: joint0) { $0 }
}
