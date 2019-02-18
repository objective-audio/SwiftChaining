//
//  CombineTuple.swift
//

import Foundation

extension Chain where Sender: Fetchable {
    public func combine<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                      _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(Out, SO1, SO2), (Out?, SO1?, SO2?), Sender> {
        return _combineToMain(main: self, sub1: subChain1, sub2: subChain2)
    }
    
    public func combine<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                      _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(Out, SO1, SO2), (Out?, SO1?, SO2?), Sender> where SS1: Fetchable {
        return _combineToMain(main: self, sub1: subChain1, sub2: subChain2)
    }
    
    public func combine<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                      _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(Out, SO1, SO2), (Out?, SO1?, SO2?), Sender> where SS2: Fetchable {
        return _combineToMain(main: self, sub1: subChain1, sub2: subChain2)
    }
    
    public func combine<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                      _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(Out, SO1, SO2), (Out?, SO1?, SO2?), Sender> where SS1: Fetchable, SS2: Fetchable {
        return _combineToMain(main: self, sub1: subChain1, sub2: subChain2)
    }
}

extension Chain {
    public func combine<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                      _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(Out, SO1, SO2), (Out?, SO1?, SO2?), Sender> {
        return _combineToMain(main: self, sub1: subChain1, sub2: subChain2)
    }
    
    public func combine<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                      _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(Out, SO1, SO2), (Out?, SO1?, SO2?), SS1> where SS1: Fetchable {
        return _combineToSub1(main: self, sub1: subChain1, sub2: subChain2)
    }
    
    public func combine<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                      _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(Out, SO1, SO2), (Out?, SO1?, SO2?), SS2> where SS2: Fetchable {
        return _combineToSub2(main: self, sub1: subChain1, sub2: subChain2)
    }
    
    public func combine<SO1, SI1, SS1, SO2, SI2, SS2>(_ subChain1: Chain<SO1, SI1, SS1>,
                                                      _ subChain2: Chain<SO2, SI2, SS2>) -> Chain<(Out, SO1, SO2), (Out?, SO1?, SO2?), SS1> where SS1: Fetchable, SS2: Fetchable {
        return _combineToSub1(main: self, sub1: subChain1, sub2: subChain2)
    }
}

private func _combineToMain<MO, MI, MS, SO1, SI1, SS1, SO2, SI2, SS2>(main: Chain<MO, MI, MS>,
                                                                      sub1: Chain<SO1, SI1, SS1>,
                                                                      sub2: Chain<SO2, SI2, SS2>) -> Chain<(MO, SO1, SO2), (MO?, SO1?, SO2?), MS> {
    var cache: (main: MO?, sub1: SO1?, sub2: SO2?) = (nil, nil, nil)
    
    return main.tuple(sub1, sub2).map({ (main, sub1, sub2) -> (MO?, SO1?, SO2?) in
        if let main = main {
            cache.main = main
        } else if let sub1 = sub1 {
            cache.sub1 = sub1
        } else if let sub2 = sub2 {
            cache.sub2 = sub2
        }
        return cache
    }).guard({ (main, sub1, sub2) in
        return main != nil && sub1 != nil && sub2 != nil
    }).map { (main, sub1, sub2) -> (MO, SO1, SO2) in
        return (main!, sub1!, sub2!)
    }
}

private func _combineToSub1<MO, MI, MS, SO1, SI1, SS1, SO2, SI2, SS2>(main: Chain<MO, MI, MS>,
                                                                      sub1: Chain<SO1, SI1, SS1>,
                                                                      sub2: Chain<SO2, SI2, SS2>) -> Chain<(MO, SO1, SO2), (MO?, SO1?, SO2?), SS1> where SS1: Fetchable {
    var cache: (main: MO?, sub1: SO1?, sub2: SO2?) = (nil, nil, nil)
    
    return main.tuple(sub1, sub2).map({ (main, sub1, sub2) -> (MO?, SO1?, SO2?) in
        if let main = main {
            cache.main = main
        } else if let sub1 = sub1 {
            cache.sub1 = sub1
        } else if let sub2 = sub2 {
            cache.sub2 = sub2
        }
        return cache
    }).guard({ (main, sub1, sub2) in
        return main != nil && sub1 != nil && sub2 != nil
    }).map { (main, sub1, sub2) -> (MO, SO1, SO2) in
        return (main!, sub1!, sub2!)
    }
}

private func _combineToSub2<MO, MI, MS, SO1, SI1, SS1, SO2, SI2, SS2>(main: Chain<MO, MI, MS>,
                                                                      sub1: Chain<SO1, SI1, SS1>,
                                                                      sub2: Chain<SO2, SI2, SS2>) -> Chain<(MO, SO1, SO2), (MO?, SO1?, SO2?), SS2> where SS2: Fetchable {
    var cache: (main: MO?, sub1: SO1?, sub2: SO2?) = (nil, nil, nil)
    
    return main.tuple(sub1, sub2).map({ (main, sub1, sub2) -> (MO?, SO1?, SO2?) in
        if let main = main {
            cache.main = main
        } else if let sub1 = sub1 {
            cache.sub1 = sub1
        } else if let sub2 = sub2 {
            cache.sub2 = sub2
        }
        return cache
    }).guard({ (main, sub1, sub2) in
        return main != nil && sub1 != nil && sub2 != nil
    }).map { (main, sub1, sub2) -> (MO, SO1, SO2) in
        return (main!, sub1!, sub2!)
    }
}
