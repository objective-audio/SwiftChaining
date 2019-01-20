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

public class SenderCore<T: Sendable> {
    private var joints: [Weak<Joint<T>>] = []
    
    internal var relaySender: AnySendable?
    internal var relayObserver: AnyObserver?
    internal var relayValueObserver: AnyObserver?
    
    public init() {}
    
    internal func broadcast(value: T.SendValue) {
        for joint in self.joints {
            joint.value?.call(first: value)
        }
    }
    
    internal func send(value: T.SendValue, to target: AnyJoint) {
        let targetId = ObjectIdentifier(target)
        for joint in self.joints {
            if joint.id == targetId {
                joint.value?.call(first: value)
                break
            }
        }
    }
    
    internal func addJoint(sender: T) -> Joint<T> {
        let joint = Joint(sender: sender)
        self.joints.append(Weak(joint))
        return joint
    }
    
    internal func remove(joint: Joint<T>) {
        let id = ObjectIdentifier(joint)
        self.joints = self.joints.filter { $0.id != id }
    }
}

public protocol Sendable: AnySendable {
    associatedtype SendValue
    var core: SenderCore<Self> { get }
}

extension Sendable {
    public typealias SenderChain = Chain<SendValue, SendValue, Self>
    
    public func broadcast(value: SendValue) {
        self.core.broadcast(value: value)
    }
    
    public func chain() -> SenderChain {
        return Chain(joint: self.core.addJoint(sender: self), handler: { $0 })
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
        if self.core.relaySender == nil {
            let notifier = RelayingNotifier()
            self.core.relaySender = notifier
            self.core.relayObserver = self.chain().do({ [weak self] value in
                notifier.notify(value: .current(value))
                
                self?.core.relayValueObserver = value.chain().do({ value in
                    notifier.core.broadcast(value: .relayed(value))
                }).end()
            }).end()
        }
        
        let notifier = self.core.relaySender as! RelayingNotifier
        
        return notifier.chain()
    }
}

extension Sendable where SendValue: Fetchable {
    public func relayedChain() -> RelayingNotifierChain {
        if self.core.relaySender == nil {
            let notifier = RelayingNotifier()
            self.core.relaySender = notifier
            self.core.relayObserver = self.chain().do({ [weak self] value in
                notifier.notify(value: .current(value))
                
                self?.core.relayValueObserver = value.chain().do({ value in
                    notifier.core.broadcast(value: .relayed(value))
                }).sync()
            }).end()
        }
        
        let notifier = self.core.relaySender as! RelayingNotifier
        
        return notifier.chain()
    }
}
