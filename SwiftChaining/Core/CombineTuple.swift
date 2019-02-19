//
//  CombineTuple.swift
//

import Foundation

extension Chain where Sender: Fetchable {
    public func combine<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                                _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out, Out1, Out2), (Out?, Out1?, Out2?), Sender> {
        return _combine0(chain0: self, chain1: chain1, chain2: chain2)
    }
    
    public func combine<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                                _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out, Out1, Out2), (Out?, Out1?, Out2?), Sender> where Sender1: Fetchable {
        return _combine0(chain0: self, chain1: chain1, chain2: chain2)
    }
    
    public func combine<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                                _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out, Out1, Out2), (Out?, Out1?, Out2?), Sender> where Sender2: Fetchable {
        return _combine0(chain0: self, chain1: chain1, chain2: chain2)
    }
    
    public func combine<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                                _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out, Out1, Out2), (Out?, Out1?, Out2?), Sender> where Sender1: Fetchable, Sender2: Fetchable {
        return _combine0(chain0: self, chain1: chain1, chain2: chain2)
    }
}

extension Chain {
    public func combine<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                                _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out, Out1, Out2), (Out?, Out1?, Out2?), Sender> {
        return _combine0(chain0: self, chain1: chain1, chain2: chain2)
    }
    
    public func combine<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                                _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out, Out1, Out2), (Out?, Out1?, Out2?), Sender1> where Sender1: Fetchable {
        return _combine1(chain0: self, chain1: chain1, chain2: chain2)
    }
    
    public func combine<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                                _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out, Out1, Out2), (Out?, Out1?, Out2?), Sender2> where Sender2: Fetchable {
        return _combine2(chain0: self, chain1: chain1, chain2: chain2)
    }
    
    public func combine<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                                _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out, Out1, Out2), (Out?, Out1?, Out2?), Sender1> where Sender1: Fetchable, Sender2: Fetchable {
        return _combine1(chain0: self, chain1: chain1, chain2: chain2)
    }
}

private func _combine0<Out0, In0, Sender0, Out1, In1, Sender1, Out2, In2, Sender2>(chain0: Chain<Out0, In0, Sender0>,
                                                                                   chain1: Chain<Out1, In1, Sender1>,
                                                                                   chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out0, Out1, Out2), (Out0?, Out1?, Out2?), Sender0> {
    var cache: (Out0?, Out1?, Out2?) = (nil, nil, nil)
    
    return chain0.tuple(chain1, chain2)
        .map {
            if let in0 = $0.0 {
                cache.0 = in0
            } else if let in1 = $0.1 {
                cache.1 = in1
            } else if let in2 = $0.2 {
                cache.2 = in2
            }
            return cache
        }
        .guard { $0.0 != nil && $0.1 != nil && $0.2 != nil }
        .map { ($0.0!, $0.1!, $0.2!) }
}

private func _combine1<Out0, In0, Sender0, Out1, In1, Sender1, Out2, In2, Sender2>(chain0: Chain<Out0, In0, Sender0>,
                                                                                   chain1: Chain<Out1, In1, Sender1>,
                                                                                   chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out0, Out1, Out2), (Out0?, Out1?, Out2?), Sender1> where Sender1: Fetchable {
    var cache: (Out0?, Out1?, Out2?) = (nil, nil, nil)
    
    return chain0.tuple(chain1, chain2)
        .map {
            if let in0 = $0.0 {
                cache.0 = in0
            } else if let in1 = $0.1 {
                cache.1 = in1
            } else if let in2 = $0.2 {
                cache.2 = in2
            }
            return cache
        }
        .guard { $0.0 != nil && $0.1 != nil && $0.2 != nil }
        .map { ($0.0!, $0.1!, $0.2!) }
}

private func _combine2<Out0, In0, Sender0, Out1, In1, Sender1, Out2, In2, Sender2>(chain0: Chain<Out0, In0, Sender0>,
                                                                                   chain1: Chain<Out1, In1, Sender1>,
                                                                                   chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out0, Out1, Out2), (Out0?, Out1?, Out2?), Sender2> where Sender2: Fetchable {
    var cache: (Out0?, Out1?, Out2?) = (nil, nil, nil)
    
    return chain0.tuple(chain1, chain2)
        .map {
            if let in0 = $0.0 {
                cache.0 = in0
            } else if let in1 = $0.1 {
                cache.1 = in1
            } else if let in2 = $0.2 {
                cache.2 = in2
            }
            return cache
        }
        .guard { $0.0 != nil && $0.1 != nil && $0.2 != nil }
        .map { ($0.0!, $0.1!, $0.2!) }
}




