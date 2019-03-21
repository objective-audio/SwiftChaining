//
//  Core.swift
//

import Foundation

public protocol AnyCore: class {
}

public class Core<T: Sendable>: AnyCore {
    private var joints: [Weak<Joint<T>>] = []
    private let removeId: ObjectIdentifier
    
    internal init(removeId: ObjectIdentifier) {
        self.removeId = removeId
    }
    
    deinit {
        CoreGlobal.removeCore(for: self.removeId)
    }
    
    internal func broadcast(value: T.SendValue) {
        for joint in self.joints {
            joint.value?.call(first: value)
        }
    }
    
    internal func send(value: T.SendValue, to target: JointClass) {
        let targetId = ObjectIdentifier(target)
        for joint in self.joints {
            if joint.id == targetId {
                joint.value?.call(first: value)
                break
            }
        }
    }
    
    internal func addJoint(sender: Reference<T>) -> Joint<T> {
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
    private static let shared = CoreGlobal()
    
    private struct CoreWrapper {
        weak var core: AnyCore?
    }
    
    private var cores: [ObjectIdentifier: CoreWrapper] = [:]
    
    internal class func set(core: AnyCore, for id: ObjectIdentifier) {
        CoreGlobal.shared.cores[id] = CoreWrapper(core: core)
    }
    
    internal class func removeCore(for id: ObjectIdentifier) {
        CoreGlobal.shared.cores.removeValue(forKey: id)
    }
    
    internal class func core<Sender: Sendable>(for sender: Sender) -> Core<Sender>? {
        return CoreGlobal.shared.cores[ObjectIdentifier(sender)]?.core as? Core<Sender>
    }
    
    internal class func getOrCreateCore<Sender: Sendable>(for sender: Sender) -> Core<Sender> {
        if let core = self.core(for: sender) {
            return core
        } else {
            let id = ObjectIdentifier(sender)
            let core = Core<Sender>(removeId: id)
            self.set(core: core, for: id)
            return core
        }
    }
}
