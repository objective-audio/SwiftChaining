//
//  Merge.swift
//

import Foundation

extension Chain where Sender: Fetchable {
    public func merge<SubIn, SubSender>(_ subChain: Chain<HandlerOut, SubIn, SubSender>) -> Chain<HandlerOut, HandlerOut, Sender> {
        return _merge(main: self, sub: subChain)
    }
}

extension Chain {
    public func merge<SubIn, SubSender>(_ subChain: Chain<HandlerOut, SubIn, SubSender>) -> Chain<HandlerOut, HandlerOut, SubSender> where SubSender: Fetchable {
        return _merge(main: subChain, sub: self)
    }
    
    public func merge<SubIn, SubSender>(_ subChain: Chain<HandlerOut, SubIn, SubSender>) -> Chain<HandlerOut, HandlerOut, Sender> {
        return _merge(main: self, sub: subChain)
    }
}

private func _merge<HandlerOut, MainIn, MainJoint, SubIn, SubSender>(main: Chain<HandlerOut, MainIn, MainJoint>, sub: Chain<HandlerOut, SubIn, SubSender>) -> Chain<HandlerOut, HandlerOut, MainJoint> {
    guard let mainJoint = main.joint, let subJoint = sub.joint else {
        fatalError()
    }
    
    main.joint = nil
    sub.joint = nil
    
    let mainHandler = main.handler
    let subHandler = sub.handler
    let nextIndex =  mainJoint.handlers.count + 1
    
    let subNewHandler: (SubIn) -> Void = { [weak mainJoint] value in
        if let mainJoint = mainJoint, let nextHandler = mainJoint.handlers[nextIndex] as? (HandlerOut) -> Void {
            nextHandler(subHandler(value))
        }
    }
    
    subJoint.handlers.append(subNewHandler)
    
    let mainNewHandler: (MainIn) -> Void = { [weak mainJoint] value in
        if let mainJoint = mainJoint, let nextHandler = mainJoint.handlers[nextIndex] as? (HandlerOut) -> Void {
            nextHandler(mainHandler(value))
        }
    }
    
    mainJoint.handlers.append(mainNewHandler)
    
    mainJoint.subJoints.append(subJoint)
    return Chain<HandlerOut, HandlerOut, MainJoint>(joint: mainJoint) { $0 }
}
