//
//  Combine.swift
//

import Foundation

extension Chain where Sender: Fetchable {
    public func combine<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out, Out1), Sender> where Sender1: Fetchable {
        return _combine0(chain0: self, chain1: chain1)
    }
    
    public func combine<Out1, Sender1, T0, T1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, Out1), Sender> where Out == (T0, T1), Sender1: Fetchable {
        return _combine0(chain0: self, chain1: chain1).map { ($0.0, $0.1, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, Out1), Sender> where Out == (T0, T1, T2), Sender1: Fetchable {
        return _combine0(chain0: self, chain1: chain1).map { ($0.0, $0.1, $0.2, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, T3, Out1), Sender> where Out == (T0, T1, T2, T3), Sender1: Fetchable {
        return _combine0(chain0: self, chain1: chain1).map { ($0.0, $0.1, $0.2, $0.3, $1) }
    }
    
    public func combine<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out, Out1), Sender> {
        return _combine0(chain0: self, chain1: chain1)
    }
    
    public func combine<Out1, Sender1, T0, T1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, Out1), Sender> where Out == (T0, T1) {
        return _combine0(chain0: self, chain1: chain1).map { ($0.0, $0.1, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, Out1), Sender> where Out == (T0, T1, T2) {
        return _combine0(chain0: self, chain1: chain1).map { ($0.0, $0.1, $0.2, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, T3, Out1), Sender> where Out == (T0, T1, T2, T3) {
        return _combine0(chain0: self, chain1: chain1).map { ($0.0, $0.1, $0.2, $0.3, $1) }
    }
}

extension Chain {
    public func combine<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out, Out1), Sender1> where Sender1: Fetchable {
        return _combine1(chain0: self, chain1: chain1)
    }
    
    public func combine<Out1, Sender1, T0, T1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, Out1), Sender1> where Out == (T0, T1), Sender1: Fetchable {
        return _combine1(chain0: self, chain1: chain1).map { ($0.0, $0.1, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, Out1), Sender1> where Out == (T0, T1, T2), Sender1: Fetchable {
        return _combine1(chain0: self, chain1: chain1).map { ($0.0, $0.1, $0.2, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, T3, Out1), Sender1> where Out == (T0, T1, T2, T3), Sender1: Fetchable {
        return _combine1(chain0: self, chain1: chain1).map { ($0.0, $0.1, $0.2, $0.3, $1) }
    }
    
    public func combine<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out, Out1), Sender> {
        return _combine0(chain0: self, chain1: chain1)
    }
    
    public func combine<Out1, Sender1, T0, T1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, Out1), Sender> where Out == (T0, T1) {
        return _combine0(chain0: self, chain1: chain1).map { ($0.0, $0.1, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, Out1), Sender> where Out == (T0, T1, T2) {
        return _combine0(chain0: self, chain1: chain1).map { ($0.0, $0.1, $0.2, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, T3, Out1), Sender> where Out == (T0, T1, T2, T3) {
        return _combine0(chain0: self, chain1: chain1).map { ($0.0, $0.1, $0.2, $0.3, $1) }
    }
}

private func _combine0<Out0, Sender0, Out1, Sender1>(chain0: Chain<Out0, Sender0>,
                                                     chain1: Chain<Out1, Sender1>) -> Chain<(Out0, Out1), Sender0> {
    var cache: (Out0?, Out1?) = (nil, nil)
    
    return chain0.tuple(chain1)
        .map { pair -> (Out0?, Out1?) in
            if let in0 = pair.0 {
                cache.0 = in0
            } else if let in1 = pair.1 {
                cache.1 = in1
            }
            return cache
        }
        .guard { $0.0 != nil && $0.1 != nil }
        .map { ($0.0!, $0.1!) }
}

private func _combine1<Out0, Sender0, Out1, Sender1>(chain0: Chain<Out0, Sender0>,
                                                     chain1: Chain<Out1, Sender1>) -> Chain<(Out0, Out1), Sender1> where Sender1: Fetchable {
    var cache: (Out0?, Out1?) = (nil, nil)
    
    return chain0.tuple(chain1)
        .map { pair -> (Out0?, Out1?) in
            if let in0 = pair.0 {
                cache.0 = in0
            } else if let in1 = pair.1 {
                cache.1 = in1
            }
            return cache
        }
        .guard { $0.0 != nil && $0.1 != nil }
        .map { ($0.0!, $0.1!) }
}
