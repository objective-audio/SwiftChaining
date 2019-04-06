//
//  Core.swift
//

import Foundation

public protocol AnyCore: class {
}

public class Core<ChainType: ChainableProtocol>: AnyCore {
    private var joints: [Weak<Joint<ChainType>>] = []
    private let removeId: ObjectIdentifier
    
    internal init(removeId: ObjectIdentifier) {
        self.removeId = removeId
    }
    
    deinit {
        CoreGlobal.removeCore(for: self.removeId)
    }
    
    internal func broadcast(value: ChainType.ChainValue) {
        for joint in self.joints {
            joint.value?.call(first: value)
        }
    }
    
    internal func send(value: ChainType.ChainValue, to target: JointClass) {
        let targetId = ObjectIdentifier(target)
        for joint in self.joints {
            if joint.id == targetId {
                joint.value?.call(first: value)
                break
            }
        }
    }
    
    internal func addJoint(chainer: Reference<AnyObject>) -> Joint<ChainType> {
        let joint = Joint<ChainType>(chainer: chainer, core: self)
        self.joints.append(Weak(joint))
        return joint
    }
    
    internal func remove(joint: Joint<ChainType>) {
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
    
    internal class func core(for chainer: AnyObject) -> AnyCore? {
        return CoreGlobal.shared.cores[ObjectIdentifier(chainer)]?.core
    }
    
    internal class func makeChain<Chainer: Chainable>(chainer: Chainer, retained: Bool) -> FirstChain<Chainer.ChainType> {
        let core = self.getOrCreateCore(for: chainer)
        
        let chainer: Reference<AnyObject> = retained ? .strong(chainer) : .weak(Weak(chainer))
        
        let joint = core.addJoint(chainer: chainer)
        
        let handler0: JointHandler<Chainer.ChainValue> = { value, joint in
            if let nextHandler = joint.handlers[1] as? JointHandler<Chainer.ChainValue> {
                nextHandler(value, joint)
            }
        }
        
        joint.appendHandler(handler0)
        
        return FirstChain(joint: joint)
    }
    
    private class func getOrCreateCore<Chainer: Chainable>(for chainer: Chainer) -> Core<Chainer.ChainType> {
        if let core = self.core(for: chainer) as? Core<Chainer.ChainType> {
            return core
        } else {
            let id = ObjectIdentifier(chainer)
            let core = Core<Chainer.ChainType>(removeId: id)
            self.set(core: core, for: id)
            return core
        }
    }
}
