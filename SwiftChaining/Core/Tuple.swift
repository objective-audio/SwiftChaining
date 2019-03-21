//
//  Pair.swift
//

import Foundation

extension Chain where Sender: Fetchable {
    public func tuple<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out?, Out1?), Sender> where Sender1: Fetchable {
        return self.tuple0(chain1)
    }
    
    public func tuple<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out?, Out1?), Sender> {
        return self.tuple0(chain1)
    }
}

extension Chain {
    public func tuple<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out?, Out1?), Sender1> where Sender1: Fetchable {
        return self.tuple1(chain1)
    }
    
    public func tuple<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out?, Out1?), Sender> {
        return self.tuple0(chain1)
    }
}

extension Chain {
    private func tuple0<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out?, Out1?), Sender> {
        guard let joint0 = self.pullJoint(), let joint1 = chain1.pullJoint() else {
            fatalError()
        }
        
        let nextIndex = joint0.handlerCount + 1
        
        let handler1: JointHandler<Out1> = { [weak joint0] value, _ in
            if let joint0 = joint0 {
                if let nextHandler = joint0.handler(at: nextIndex) as? JointHandler<(Out?, Out1?)> {
                    nextHandler((nil, value), joint0)
                }
            }
        }
        
        joint1.appendHandler(handler1)
        
        let handler0: JointHandler<Out> = { value, joint in
            if let nextHandler = joint.handler(at: nextIndex) as? JointHandler<(Out?, Out1?)> {
                nextHandler((value, nil), joint)
            }
        }
        
        joint0.appendHandler(handler0)
        joint0.appendSubJoint(joint1)
        
        return Chain<(Out?, Out1?), Sender>(joint: joint0)
    }
    
    private func tuple1<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out?, Out1?), Sender1> {
        guard let joint0 = self.pullJoint(), let joint1 = chain1.pullJoint() else {
            fatalError()
        }
        
        let nextIndex = joint1.handlerCount + 1
        
        let newHandler1: JointHandler<Out1> = { value, joint in
            if let nextHandler = joint.handler(at: nextIndex) as? JointHandler<(Out?, Out1?)> {
                nextHandler((nil, value), joint)
            }
        }
        
        joint1.appendHandler(newHandler1)
        
        let newHandler0: JointHandler<Out> = { [weak joint1] value, _ in
            if let joint1 = joint1, let nextHandler = joint1.handler(at: nextIndex) as? JointHandler<(Out?, Out1?)> {
                nextHandler((value, nil), joint1)
            }
        }
        
        joint0.appendHandler(newHandler0)
        joint1.appendSubJoint(joint0)
        
        return Chain<(Out?, Out1?), Sender1>(joint: joint1)
    }
}
