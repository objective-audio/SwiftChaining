//
//  Pair.swift
//

import Foundation

extension Chain where Sender: Fetchable {
    public func tuple<Out1, In1, Sender1>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(Out?, Out1?), (Out?, Out1?), Sender> where Sender1: Fetchable {
        return _tuple0(chain0: self, chain1: chain1)
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, Out1?), (Out?, Out1?), Sender> where Out == (T0?, T1?), Sender1: Fetchable {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $1) }
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, T2?, Out1?), (Out?, Out1?), Sender> where Out == (T0?, T1?, T2?), Sender1: Fetchable {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $1) }
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, T2?, T3?, Out1?), (Out?, Out1?), Sender> where Out == (T0?, T1?, T2?, T3?), Sender1: Fetchable {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $0?.3, $1) }
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1, T2, T3, T4>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, T2?, T3?, T4?, Out1?), (Out?, Out1?), Sender> where Out == (T0?, T1?, T2?, T3?, T4?), Sender1: Fetchable {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $0?.3, $0?.4, $1) }
    }
    
    public func tuple<Out1, In1, Sender1>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(Out?, Out1?), (Out?, Out1?), Sender> {
        return _tuple0(chain0: self, chain1: chain1)
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, Out1?), (Out?, Out1?), Sender> where Out == (T0?, T1?) {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $1) }
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, T2?, Out1?), (Out?, Out1?), Sender> where Out == (T0?, T1?, T2?) {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $1) }
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, T2?, T3?, Out1?), (Out?, Out1?), Sender> where Out == (T0?, T1?, T2?, T3?) {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $0?.3, $1) }
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1, T2, T3, T4>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, T2?, T3?, T4?, Out1?), (Out?, Out1?), Sender> where Out == (T0?, T1?, T2?, T3?, T4?) {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $0?.3, $0?.4, $1) }
    }
}

extension Chain {
    public func tuple<Out1, In1, Sender1>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(Out?, Out1?), (Out?, Out1?), Sender1> where Sender1: Fetchable {
        return _tuple1(chain0: self, chain1: chain1)
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, Out1?), (Out?, Out1?), Sender1> where Out == (T0?, T1?), Sender1: Fetchable {
        return _tuple1(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $1) }
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, T2?, Out1?), (Out?, Out1?), Sender1> where Out == (T0?, T1?, T2?), Sender1: Fetchable {
        return _tuple1(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $1) }
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, T2?, T3?, Out1?), (Out?, Out1?), Sender1> where Out == (T0?, T1?, T2?, T3?), Sender1: Fetchable {
        return _tuple1(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $0?.3, $1) }
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1, T2, T3, T4>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, T2?, T3?, T4?, Out1?), (Out?, Out1?), Sender1> where Out == (T0?, T1?, T2?, T3?, T4?), Sender1: Fetchable {
        return _tuple1(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $0?.3, $0?.4, $1) }
    }
    
    public func tuple<Out1, In1, Sender1>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(Out?, Out1?), (Out?, Out1?), Sender> {
        return _tuple0(chain0: self, chain1: chain1)
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, Out1?), (Out?, Out1?), Sender> where Out == (T0?, T1?) {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $1) }
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, T2?, Out1?), (Out?, Out1?), Sender> where Out == (T0?, T1?, T2?) {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $1) }
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, T2?, T3?, Out1?), (Out?, Out1?), Sender> where Out == (T0?, T1?, T2?, T3?) {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $0?.3, $1) }
    }
    
    public func tuple<Out1, In1, Sender1, T0, T1, T2, T3, T4>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(T0?, T1?, T2?, T3?, T4?, Out1?), (Out?, Out1?), Sender> where Out == (T0?, T1?, T2?, T3?, T4?) {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $0?.3, $0?.4, $1) }
    }
}

private func _tuple0<Out0, In0, Sender0, Out1, In1, Sender1>(chain0: Chain<Out0, In0, Sender0>,
                                                             chain1: Chain<Out1, In1, Sender1>) -> Chain<(Out0?, Out1?), (Out0?, Out1?), Sender0> {
    guard let joint0 = chain0.joint, let joint1 = chain1.joint else {
        fatalError()
    }
    
    chain0.joint = nil
    chain1.joint = nil
    
    let handler0 = chain0.handler
    let handler1 = chain1.handler
    let nextIndex = joint0.handlers.count + 1
    
    let newHandler1: (In1) -> Void = { [weak joint0] value in
        if let joint0 = joint0 {
            let nextHandler = joint0.handlers[nextIndex] as! ((Out0?, Out1?)) -> Void
            nextHandler((nil, handler1(value)))
        }
    }
    
    joint1.handlers.append(newHandler1)
    
    let newHandler0: (In0) -> Void = { [weak joint0] value in
        if let joint0 = joint0 {
            let nextHandler = joint0.handlers[nextIndex] as! ((Out0?, Out1?)) -> Void
            nextHandler((handler0(value), nil))
        }
    }
    
    joint0.handlers.append(newHandler0)
    
    joint0.subJoints.append(joint1)
    
    return Chain<(Out0?, Out1?), (Out0?, Out1?), Sender0>(joint: joint0) { $0 }
}

internal func _tuple1<Out0, In0, Sender0, Out1, In1, Sender1>(chain0: Chain<Out0, In0, Sender0>,
                                                              chain1: Chain<Out1, In1, Sender1>) -> Chain<(Out0?, Out1?), (Out0?, Out1?), Sender1> {
    guard let joint0 = chain0.joint, let joint1 = chain1.joint else {
        fatalError()
    }
    
    chain0.joint = nil
    chain1.joint = nil
    
    let handler0 = chain0.handler
    let handler1 = chain1.handler
    let nextIndex = joint1.handlers.count + 1
    
    let newHandler1: (In1) -> Void = { [weak joint1] value in
        if let joint1 = joint1 {
            let nextHandler = joint1.handlers[nextIndex] as! ((Out0?, Out1?)) -> Void
            nextHandler((nil, handler1(value)))
        }
    }
    
    joint1.handlers.append(newHandler1)
    
    let newHandler0: (In0) -> Void = { [weak joint1] value in
        if let joint1 = joint1 {
            let nextHandler = joint1.handlers[nextIndex] as! ((Out0?, Out1?)) -> Void
            nextHandler((handler0(value), nil))
        }
    }
    
    joint0.handlers.append(newHandler0)
    
    joint1.subJoints.append(joint0)
    
    return Chain<(Out0?, Out1?), (Out0?, Out1?), Sender1>(joint: joint1) { $0 }
}


