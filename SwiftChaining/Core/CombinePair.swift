//
//  Combine.swift
//

import Foundation

extension Chain where Sender: Fetchable {
    public func combine<SubOut, SubIn, SubSender>(_ subChain: Chain<SubOut, SubIn, SubSender>) -> Chain<(HandlerOut, SubOut), (HandlerOut?, SubOut?), Sender> where SubSender: Fetchable {
        return _combineToMain(main: self, sub: subChain)
    }
    
    public func combine<SubOut, SubIn, SubSender>(_ subChain: Chain<SubOut, SubIn, SubSender>) -> Chain<(HandlerOut, SubOut), (HandlerOut?, SubOut?), Sender> {
        return _combineToMain(main: self, sub: subChain)
    }
}

extension Chain {
    public func combine<SubOut, SubIn, SubSender>(_ subChain: Chain<SubOut, SubIn, SubSender>) -> Chain<(HandlerOut, SubOut), (HandlerOut?, SubOut?), SubSender> where SubSender: Fetchable {
        return _combineToSub(main: self, sub: subChain)
    }
    
    public func combine<SubOut, SubIn, SubSender>(_ subChain: Chain<SubOut, SubIn, SubSender>) -> Chain<(HandlerOut, SubOut), (HandlerOut?, SubOut?), Sender> {
        return _combineToMain(main: self, sub: subChain)
    }
}

private func _combineToMain<MainOut, MainIn, MainSender, SubOut, SubIn, SubSender>(main: Chain<MainOut, MainIn, MainSender>, sub: Chain<SubOut, SubIn, SubSender>) -> Chain<(MainOut, SubOut), (MainOut?, SubOut?), MainSender> {
    var cache: (lhs: MainOut?, rhs: SubOut?) = (nil, nil)
    return main.pair(sub).map({ (lhs, rhs) in
        if let lhs = lhs {
            cache.lhs = lhs
        } else if let rhs = rhs {
            cache.rhs = rhs
        }
        return cache
    }).guard({ (lhs, rhs) in
        return lhs != nil && rhs != nil
    }).map({ (lhs, rhs) -> (MainOut, SubOut) in
        return (lhs!, rhs!)
    })
}

private func _combineToSub<MainOut, MainIn, MainSender, SubOut, SubIn, SubSender>(main: Chain<MainOut, MainIn, MainSender>, sub: Chain<SubOut, SubIn, SubSender>) -> Chain<(MainOut, SubOut), (MainOut?, SubOut?), SubSender> where SubSender: Fetchable {
    var cache: (lhs: MainOut?, rhs: SubOut?) = (nil, nil)
    return main.pair(sub).map({ (lhs, rhs) in
        if let lhs = lhs {
            cache.lhs = lhs
        } else if let rhs = rhs {
            cache.rhs = rhs
        }
        return cache
    }).guard({ (lhs, rhs) in
        return lhs != nil && rhs != nil
    }).map({ (lhs, rhs) -> (MainOut, SubOut) in
        return (lhs!, rhs!)
    })
}
