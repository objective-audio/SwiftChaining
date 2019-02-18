//
//  Tuple.swift
//

import Foundation

extension Chain where Sender: Fetchable {
    public func tuple<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                    _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(HandlerOut?, SO1?, SO2?), ((HandlerOut?, SO1?)?, SO2?), Sender> {
        return _tupleToMain(self, subChain1, subChain2)
    }
    
    public func tuple<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                    _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(HandlerOut?, SO1?, SO2?), ((HandlerOut?, SO1?)?, SO2?), Sender> where SS1: Fetchable {
        return _tupleToMain(self, subChain1, subChain2)
    }
    
    public func tuple<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                    _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(HandlerOut?, SO1?, SO2?), ((HandlerOut?, SO1?)?, SO2?), Sender> where SS2: Fetchable {
        return _tupleToMain(self, subChain1, subChain2)
    }
    
    public func tuple<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                    _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(HandlerOut?, SO1?, SO2?), ((HandlerOut?, SO1?)?, SO2?), Sender> where SS1: Fetchable, SS2: Fetchable {
        return _tupleToMain(self, subChain1, subChain2)
    }
}

extension Chain {
    public func tuple<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                    _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(HandlerOut?, SO1?, SO2?), ((HandlerOut?, SO1?)?, SO2?), Sender> {
        return _tupleToMain(self, subChain1, subChain2)
    }
    
    public func tuple<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                    _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(HandlerOut?, SO1?, SO2?), ((HandlerOut?, SO1?)?, SO2?), SS1> where SS1: Fetchable {
        return _tupleToSub1(self, subChain1, subChain2)
    }
    
    public func tuple<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                    _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(HandlerOut?, SO1?, SO2?), ((HandlerOut?, SO1?)?, SO2?), SS2> where SS2: Fetchable {
        return _tupleToSub2(self, subChain1, subChain2)
    }
    
    public func tuple<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                    _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(HandlerOut?, SO1?, SO2?), ((HandlerOut?, SO1?)?, SO2?), SS1> where SS1: Fetchable, SS2: Fetchable {
        return _tupleToSub1(self, subChain1, subChain2)
    }
}

private func _tupleToMain<MO, MI, MS, SO1, SI1, SS1, SO2, SI2, SS2>(_ mainChain: Chain<MO, MI, MS>, _ subChain1: Chain<SO1, SI1, SS1>, _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(MO?, SO1?, SO2?), ((MO?, SO1?)?, SO2?), MS> {
    return mainChain.tuple(subChain1).tuple(subChain2).map(_flat)
}

private func _tupleToSub1<MO, MI, MS, SO1, SI1, SS1, SO2, SI2, SS2>(_ mainChain: Chain<MO, MI, MS>, _ subChain1: Chain<SO1, SI1, SS1>, _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(MO?, SO1?, SO2?), ((MO?, SO1?)?, SO2?), SS1> {
    return _tupleToSub(main: mainChain, sub: subChain1).tuple(subChain2).map(_flat)
}

private func _tupleToSub2<MO, MI, MS, SO1, SI1, SS1, SO2, SI2, SS2>(_ mainChain: Chain<MO, MI, MS>, _ subChain1: Chain<SO1, SI1, SS1>, _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(MO?, SO1?, SO2?), ((MO?, SO1?)?, SO2?), SS2> {
    return _tupleToSub(main: mainChain.tuple(subChain1), sub: subChain2).map(_flat)
}

private func _flat<MO, SO1, SO2>(_ lhs: (MO?, SO1?)?, _ rhs: SO2?) -> (MO?, SO1?, SO2?) {
    if let lhs = lhs {
        return (lhs.0, lhs.1, nil)
    } else if let rhs = rhs {
        return (nil, nil, rhs)
    } else {
        fatalError()
    }
}
