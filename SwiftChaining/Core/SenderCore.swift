//
//  SenderCore.swift
//

import Foundation

public protocol AnySenderCore: class {
}

public class SenderCore<T: Sendable>: AnySenderCore {
    private var joints: [Weak<Joint<T>>] = []
    private let removeId: ObjectIdentifier
    
    internal var relaySender: AnySendable?
    internal var relayObserver: AnyObserver?
    internal var relayValueObserver: AnyObserver?
    
    public init(removeId: ObjectIdentifier) {
        self.removeId = removeId
    }
    
    deinit {
        CoreGlobal.shared.removeCore(for: self.removeId)
    }
    
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
        let joint = Joint(sender: sender, core: self)
        self.joints.append(Weak(joint))
        return joint
    }
    
    internal func remove(joint: Joint<T>) {
        let id = ObjectIdentifier(joint)
        self.joints = self.joints.filter { $0.id != id }
    }
}

internal class CoreGlobal {
    internal static let shared = CoreGlobal()
    
    private struct CoreWrapper {
        weak var core: AnySenderCore?
    }
    
    private var cores: [ObjectIdentifier: CoreWrapper] = [:]
    
    internal func set(core: AnySenderCore, for id: ObjectIdentifier) {
        self.cores[id] = CoreWrapper(core: core)
    }
    
    internal func removeCore(for id: ObjectIdentifier) {
        self.cores.removeValue(forKey: id)
    }
    
    internal func core<T: AnySenderCore>(for id: ObjectIdentifier) -> T? {
        return cores[id]?.core as? T
    }
}
