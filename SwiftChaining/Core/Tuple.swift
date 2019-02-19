//
//  Tuple.swift
//

import Foundation

extension Chain where Sender: Fetchable {
    public func tuple<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                              _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out?, Out1?, Out2?), ((Out?, Out1?)?, Out2?), Sender> {
        return _tuple0(self, chain1, chain2)
    }
    
    public func tuple<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                              _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out?, Out1?, Out2?), ((Out?, Out1?)?, Out2?), Sender> where Sender1: Fetchable {
        return _tuple0(self, chain1, chain2)
    }
    
    public func tuple<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                              _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out?, Out1?, Out2?), ((Out?, Out1?)?, Out2?), Sender> where Sender2: Fetchable {
        return _tuple0(self, chain1, chain2)
    }
    
    public func tuple<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                              _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out?, Out1?, Out2?), ((Out?, Out1?)?, Out2?), Sender> where Sender1: Fetchable, Sender2: Fetchable {
        return _tuple0(self, chain1, chain2)
    }
}

extension Chain {
    public func tuple<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                              _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out?, Out1?, Out2?), ((Out?, Out1?)?, Out2?), Sender> {
        return _tuple0(self, chain1, chain2)
    }
    
    public func tuple<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                              _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out?, Out1?, Out2?), ((Out?, Out1?)?, Out2?), Sender1> where Sender1: Fetchable {
        return _tuple1(self, chain1, chain2)
    }
    
    public func tuple<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                              _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out?, Out1?, Out2?), ((Out?, Out1?)?, Out2?), Sender2> where Sender2: Fetchable {
        return _tuple2(self, chain1, chain2)
    }
    
    public func tuple<Out1, In1, Sender1, Out2, In2, Sender2>(_ chain1: Chain<Out1, In1, Sender1>,
                                                              _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out?, Out1?, Out2?), ((Out?, Out1?)?, Out2?), Sender1> where Sender1: Fetchable, Sender2: Fetchable {
        return _tuple1(self, chain1, chain2)
    }
}

private func _tuple0<Out0, In0, Sender0, Out1, In1, Sender1, Out2, In2, Sender2>(_ chain0: Chain<Out0, In0, Sender0>,
                                                                                 _ chain1: Chain<Out1, In1, Sender1>,
                                                                                 _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out0?, Out1?, Out2?), ((Out0?, Out1?)?, Out2?), Sender0> {
    return chain0.tuple(chain1).tuple(chain2).map(_flat3)
}

private func _tuple1<Out0, In0, Sender0, Out1, In1, Sender1, Out2, In2, Sender2>(_ chain0: Chain<Out0, In0, Sender0>,
                                                                                 _ chain1: Chain<Out1, In1, Sender1>,
                                                                                 _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out0?, Out1?, Out2?), ((Out0?, Out1?)?, Out2?), Sender1> {
    return _tuple1(chain0: chain0, chain1: chain1).tuple(chain2).map(_flat3)
}

private func _tuple2<Out0, In0, Sender0, Out1, In1, Sender1, Out2, In2, Sender2>(_ chain0: Chain<Out0, In0, Sender0>,
                                                                                 _ chain1: Chain<Out1, In1, Sender1>,
                                                                                 _ chain2: Chain<Out2, In2, Sender2>) -> Chain<(Out0?, Out1?, Out2?), ((Out0?, Out1?)?, Out2?), Sender2> {
    return _tuple1(chain0: chain0.tuple(chain1), chain1: chain2).map(_flat3)
}

private func _flat3<Out0, Out1, Out2>(_ lhs: (Out0?, Out1?)?, _ rhs: Out2?) -> (Out0?, Out1?, Out2?) {
    if let lhs = lhs {
        return (lhs.0, lhs.1, nil)
    } else if let rhs = rhs {
        return (nil, nil, rhs)
    } else {
        fatalError()
    }
}



