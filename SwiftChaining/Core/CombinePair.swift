//
//  Combine.swift
//

import Foundation

extension Chain where Sender: Fetchable {
    public func combine<Out1, In1, Sender1>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(Out, Out1), (Out?, Out1?), Sender> where Sender1: Fetchable {
        return _combine0(chain0: self, chain1: chain1)
    }
    
    public func combine<Out1, In1, Sender1>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(Out, Out1), (Out?, Out1?), Sender> {
        return _combine0(chain0: self, chain1: chain1)
    }
}

extension Chain {
    public func combine<Out1, In1, Sender1>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(Out, Out1), (Out?, Out1?), Sender1> where Sender1: Fetchable {
        return _combine1(chain0: self, chain1: chain1)
    }
    
    public func combine<Out1, In1, Sender1>(_ chain1: Chain<Out1, In1, Sender1>) -> Chain<(Out, Out1), (Out?, Out1?), Sender> {
        return _combine0(chain0: self, chain1: chain1)
    }
}

private func _combine0<Out0, In0, Sender0, Out1, In1, Sender1>(chain0: Chain<Out0, In0, Sender0>,
                                                               chain1: Chain<Out1, In1, Sender1>) -> Chain<(Out0, Out1), (Out0?, Out1?), Sender0> {
    var cache: (Out0?, Out1?) = (nil, nil)
    
    return chain0.tuple(chain1)
        .map {
            if let in0 = $0.0 {
                cache.0 = in0
            } else if let in1 = $0.1 {
                cache.1 = in1
            }
            return cache
        }
        .guard { $0.0 != nil && $0.1 != nil }
        .map { ($0.0!, $0.1!) }
}

private func _combine1<Out0, In0, Sender0, Out1, In1, Sender1>(chain0: Chain<Out0, In0, Sender0>,
                                                               chain1: Chain<Out1, In1, Sender1>) -> Chain<(Out0, Out1), (Out0?, Out1?), Sender1> where Sender1: Fetchable {
    var cache: (Out0?, Out1?) = (nil, nil)
    
    return chain0.tuple(chain1)
        .map {
            if let in0 = $0.0 {
                cache.0 = in0
            } else if let in1 = $0.1 {
                cache.1 = in1
            }
            return cache
        }
        .guard { $0.0 != nil && $0.1 != nil }
        .map { ($0.0!, $0.1!) }
}


