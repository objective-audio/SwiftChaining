//
//  Pair.swift
//

import Foundation

extension Chain where Sender: Fetchable {
    public func tuple<SubOut, SubIn, SubSender>(_ subChain: Chain<SubOut, SubIn, SubSender>) -> Chain<(HandlerOut?, SubOut?), (HandlerOut?, SubOut?), Sender> where SubSender: Fetchable {
        return _pairToMain(main: self, sub: subChain)
    }
    
    public func tuple<SubOut, SubIn, SubSender>(_ subChain: Chain<SubOut, SubIn, SubSender>) -> Chain<(HandlerOut?, SubOut?), (HandlerOut?, SubOut?), Sender> {
        return _pairToMain(main: self, sub: subChain)
    }
}

extension Chain {
    public func tuple<SubOut, SubIn, SubSender>(_ subChain: Chain<SubOut, SubIn, SubSender>) -> Chain<(HandlerOut?, SubOut?), (HandlerOut?, SubOut?), SubSender> where SubSender: Fetchable {
        return _pairToSub(main: self, sub: subChain)
    }
    
    public func tuple<SubOut, SubIn, SubSender>(_ subChain: Chain<SubOut, SubIn, SubSender>) -> Chain<(HandlerOut?, SubOut?), (HandlerOut?, SubOut?), Sender> {
        return _pairToMain(main: self, sub: subChain)
    }
}

private func _pairToMain<MainOut, MainIn, MainSender, SubOut, SubIn, SubSender>(main: Chain<MainOut, MainIn, MainSender>, sub: Chain<SubOut, SubIn, SubSender>) -> Chain<(MainOut?, SubOut?), (MainOut?, SubOut?), MainSender> {
    guard let mainJoint = main.joint, let subJoint = sub.joint else {
        fatalError()
    }
    
    main.joint = nil
    sub.joint = nil
    
    let mainHandler = main.handler
    let subHandler = sub.handler
    let nextIndex = mainJoint.handlers.count + 1
    
    let subNewHandler: (SubIn) -> Void = { [weak mainJoint] value in
        if let mainJoint = mainJoint {
            let nextHandler = mainJoint.handlers[nextIndex] as! ((MainOut?, SubOut?)) -> Void
            nextHandler((nil, subHandler(value)))
        }
    }
    
    subJoint.handlers.append(subNewHandler)
    
    let mainNewHandler: (MainIn) -> Void = { [weak mainJoint] value in
        if let mainJoint = mainJoint {
            let nextHandler = mainJoint.handlers[nextIndex] as! ((MainOut?, SubOut?)) -> Void
            nextHandler((mainHandler(value), nil))
        }
    }
    
    mainJoint.handlers.append(mainNewHandler)
    
    mainJoint.subJoints.append(subJoint)
    
    return Chain<(MainOut?, SubOut?), (MainOut?, SubOut?), MainSender>(joint: mainJoint) { $0 }
}

internal func _pairToSub<MainOut, MainIn, MainSender, SubOut, SubIn, SubSender>(main: Chain<MainOut, MainIn, MainSender>, sub: Chain<SubOut, SubIn, SubSender>) -> Chain<(MainOut?, SubOut?), (MainOut?, SubOut?), SubSender> {
    guard let mainJoint = main.joint, let subJoint = sub.joint else {
        fatalError()
    }
    
    main.joint = nil
    sub.joint = nil
    
    let mainHandler = main.handler
    let subHandler = sub.handler
    let nextIndex = subJoint.handlers.count + 1
    
    let subNewHandler: (SubIn) -> Void = { [weak subJoint] value in
        if let subJoint = subJoint {
            let nextHandler = subJoint.handlers[nextIndex] as! ((MainOut?, SubOut?)) -> Void
            nextHandler((nil, subHandler(value)))
        }
    }
    
    subJoint.handlers.append(subNewHandler)
    
    let mainNewHandler: (MainIn) -> Void = { [weak subJoint] value in
        if let subJoint = subJoint {
            let nextHandler = subJoint.handlers[nextIndex] as! ((MainOut?, SubOut?)) -> Void
            nextHandler((mainHandler(value), nil))
        }
    }
    
    mainJoint.handlers.append(mainNewHandler)
    
    subJoint.subJoints.append(mainJoint)
    
    return Chain<(MainOut?, SubOut?), (MainOut?, SubOut?), SubSender>(joint: subJoint) { $0 }
}
