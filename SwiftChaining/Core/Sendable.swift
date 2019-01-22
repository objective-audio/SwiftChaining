//
//  Sendable.swift
//

import Foundation

public protocol AnySendable: class {
    func fetch(for: AnyJoint)
}

extension AnySendable {
    public func fetch(for: AnyJoint) {}
}

public protocol Sendable: AnySendable {
    associatedtype SendValue

    func getOrCreateCore() -> SenderCore<Self>
    func getCore() -> SenderCore<Self>?
}

extension Sendable {
    public typealias SenderChain = Chain<SendValue, SendValue, Self>
    
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

public enum SenderEvent<T: Sendable> where T.SendValue: Sendable {
    case current(T.SendValue)
    case relayed(T.SendValue.SendValue)
}

extension Sendable where SendValue: Sendable {
    public typealias RelayingEvent = SenderEvent<Self>
    public typealias RelayingNotifier = Notifier<RelayingEvent>
    public typealias RelayingNotifierChain = Chain<RelayingEvent, RelayingEvent, RelayingNotifier>
    
    public func relayedChain() -> RelayingNotifierChain {
        let core = self.getOrCreateCore()
        
        if core.relaySender == nil {
            let notifier = RelayingNotifier()
            core.relaySender = notifier
            core.relayObserver = self.chain().do({ [weak self] value in
                notifier.notify(value: .current(value))
                
                self?.getCore()?.relayValueObserver = value.chain().do({ value in
                    notifier.getCore()?.broadcast(value: .relayed(value))
                }).end()
            }).end()
        }
        
        let notifier = core.relaySender as! RelayingNotifier
        
        return notifier.chain()
    }
}

extension Sendable where SendValue: Fetchable {
    public func relayedChain() -> RelayingNotifierChain {
        let core = self.getOrCreateCore()
        
        if core.relaySender == nil {
            let notifier = RelayingNotifier()
            core.relaySender = notifier
            core.relayObserver = self.chain().do({ [weak self] value in
                notifier.notify(value: .current(value))
                
                self?.getCore()?.relayValueObserver = value.chain().do({ value in
                    notifier.getCore()?.broadcast(value: .relayed(value))
                }).sync()
            }).end()
        }
        
        let notifier = core.relaySender as! RelayingNotifier
        
        return notifier.chain()
    }
}
