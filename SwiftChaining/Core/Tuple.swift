//
//  Pair.swift
//

import Foundation

extension Chain where Sender: Fetchable {
    public func tuple<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out?, Out1?), Sender> where Sender1: Fetchable {
        return _tuple0(chain0: self, chain1: chain1)
    }
    
    public func tuple<Out1, Sender1, T0, T1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0?, T1?, Out1?), Sender> where Out == (T0?, T1?), Sender1: Fetchable {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $1) }
    }
    
    public func tuple<Out1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0?, T1?, T2?, Out1?), Sender> where Out == (T0?, T1?, T2?), Sender1: Fetchable {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $1) }
    }
    
    public func tuple<Out1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0?, T1?, T2?, T3?, Out1?), Sender> where Out == (T0?, T1?, T2?, T3?), Sender1: Fetchable {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $0?.3, $1) }
    }
    
    public func tuple<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out?, Out1?), Sender> {
        return _tuple0(chain0: self, chain1: chain1)
    }
    
    public func tuple<Out1, Sender1, T0, T1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0?, T1?, Out1?), Sender> where Out == (T0?, T1?) {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $1) }
    }
    
    public func tuple<Out1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0?, T1?, T2?, Out1?), Sender> where Out == (T0?, T1?, T2?) {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $1) }
    }
    
    public func tuple<Out1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0?, T1?, T2?, T3?, Out1?), Sender> where Out == (T0?, T1?, T2?, T3?) {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $0?.3, $1) }
    }
}

extension Chain {
    public func tuple<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out?, Out1?), Sender1> where Sender1: Fetchable {
        return _tuple1(chain0: self, chain1: chain1)
    }
    
    public func tuple<Out1, Sender1, T0, T1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0?, T1?, Out1?), Sender1> where Out == (T0?, T1?), Sender1: Fetchable {
        return _tuple1(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $1) }
    }
    
    public func tuple<Out1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0?, T1?, T2?, Out1?), Sender1> where Out == (T0?, T1?, T2?), Sender1: Fetchable {
        return _tuple1(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $1) }
    }
    
    public func tuple<Out1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0?, T1?, T2?, T3?, Out1?), Sender1> where Out == (T0?, T1?, T2?, T3?), Sender1: Fetchable {
        return _tuple1(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $0?.3, $1) }
    }
    
    public func tuple<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out?, Out1?), Sender> {
        return _tuple0(chain0: self, chain1: chain1)
    }
    
    public func tuple<Out1, Sender1, T0, T1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0?, T1?, Out1?), Sender> where Out == (T0?, T1?) {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $1) }
    }
    
    public func tuple<Out1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0?, T1?, T2?, Out1?), Sender> where Out == (T0?, T1?, T2?) {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $1) }
    }
    
    public func tuple<Out1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0?, T1?, T2?, T3?, Out1?), Sender> where Out == (T0?, T1?, T2?, T3?) {
        return _tuple0(chain0: self, chain1: chain1).map { ($0?.0, $0?.1, $0?.2, $0?.3, $1) }
    }
}

private func _tuple0<Out0, Sender0, Out1, Sender1>(chain0: Chain<Out0, Sender0>,
                                                   chain1: Chain<Out1,
    Sender1>) -> Chain<(Out0?, Out1?), Sender0> {
    guard let joint0 = chain0.pullJoint(), let joint1 = chain1.pullJoint() else {
        fatalError()
    }
    
    let nextIndex = joint0.handlerCount + 1
    
    let handler1: JointHandler<Out1> = { [weak joint0] value, _ in
        if let joint0 = joint0 {
            if let nextHandler = joint0.handler(at: nextIndex) as? JointHandler<(Out0?, Out1?)> {
                nextHandler((nil, value), joint0)
            }
        }
    }
    
    joint1.appendHandler(handler1)
    
    let handler0: JointHandler<Out0> = { value, joint in
        if let nextHandler = joint.handler(at: nextIndex) as? JointHandler<(Out0?, Out1?)> {
            nextHandler((value, nil), joint)
        }
    }
    
    joint0.appendHandler(handler0)
    
    joint0.subJoints.append(joint1)
    
    return Chain<(Out0?, Out1?), Sender0>(joint: joint0)
}

internal func _tuple1<Out0, Sender0, Out1, Sender1>(chain0: Chain<Out0, Sender0>,
                                                    chain1: Chain<Out1, Sender1>) -> Chain<(Out0?, Out1?), Sender1> {
    guard let joint0 = chain0.pullJoint(), let joint1 = chain1.pullJoint() else {
        fatalError()
    }
    
    let nextIndex = joint1.handlerCount + 1
    
    let newHandler1: JointHandler<Out1> = { value, joint in
        if let nextHandler = joint.handler(at: nextIndex) as? JointHandler<(Out0?, Out1?)> {
            nextHandler((nil, value), joint)
        }
    }
    
    joint1.appendHandler(newHandler1)
    
    let newHandler0: JointHandler<Out0> = { [weak joint1] value, _ in
        if let joint1 = joint1, let nextHandler = joint1.handler(at: nextIndex) as? JointHandler<(Out0?, Out1?)> {
            nextHandler((value, nil), joint1)
        }
    }
    
    joint0.appendHandler(newHandler0)
    
    joint1.subJoints.append(joint0)
    
    return Chain<(Out0?, Out1?), Sender1>(joint: joint1)
}

