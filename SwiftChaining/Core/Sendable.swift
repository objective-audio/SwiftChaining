//
//  Sendable.swift
//

import Foundation

public protocol AnySendable: class {
    func fetch(for: JointClass)
}

extension AnySendable {
    public func fetch(for: JointClass) {}
}

public protocol Sendable: AnySendable {
    associatedtype SendValue
    
    typealias SenderChain = Chain<SendValue, SendValue, Self>

    func getOrCreateCore() -> SenderCore<Self>
    func getCore() -> SenderCore<Self>?
}

extension Sendable {
    public func broadcast(value: SendValue) {
        self.getCore()?.broadcast(value: value)
    }
    
    public func chain() -> SenderChain {
        let core = self.getOrCreateCore()
        let joint = core.addJoint(sender: self)
        return Chain(joint: joint, handler: { $0 })
    }
    
    public func getOrCreateCore() -> SenderCore<Self> {
        let id = ObjectIdentifier(self)
        
        if let core = CoreGlobal.shared.core(for: id) as SenderCore<Self>? {
            return core
        } else {
            let core = SenderCore<Self>(removeId: id)
            CoreGlobal.shared.set(core: core, for: id)
            return core
        }
    }
    
    public func getCore() -> SenderCore<Self>? {
        return CoreGlobal.shared.core(for: ObjectIdentifier(self)) as SenderCore<Self>?
    }
}
