//
//  Joint.swift
//

import Foundation

public protocol JointClass: class {}

internal protocol AnyJoint: JointClass {
    func handler(at: Int) -> Any
    func fetch()
    func invalidate()
}

internal typealias JointHandler<T> = (T, AnyJoint) -> Void

internal class Joint<Chainer: Chainable> {
    internal typealias Value = Chainer.ChainValue
    
    internal var chainer: Chainer? { return self.senderReference?.value }
    internal private(set) var senderReference: Reference<Chainer>?
    private var handlers: [Any] = []
    internal var handlerCount: Int { return self.handlers.count }
    private var subJoints: [AnyJoint] = []
    private var core: AnyCore?
    private let lock = NSLock()
    
    internal init(sender: Reference<Chainer>, core: AnyCore) {
        self.senderReference = sender
        self.core = core
    }
    
    deinit {
        if let sender = self.chainer {
            CoreGlobal.core(for: sender)?.remove(joint: self)
        }
    }
    
    internal func handler(at index: Int) -> Any {
        return self.handlers[index]
    }
    
    internal func appendHandler(_ handler: Any) {
        self.handlers.append(handler)
    }
    
    internal func appendSubJoint(_ joint: AnyJoint) {
        self.subJoints.append(joint)
    }
    
    internal func call(first value: Value) {
        if self.lock.try() {
            if let handler = self.handlers.first as? JointHandler<Value> {
                handler(value, self)
            }
            self.lock.unlock()
        }
    }
}

extension Joint: AnyJoint {
    internal func fetch() {
        self.chainer?.fetch(for: self)
        
        for subJoint in self.subJoints {
            subJoint.fetch()
        }
    }
    
    internal func invalidate() {
        for subJoint in self.subJoints {
            subJoint.invalidate()
        }
        
        if let sender = self.chainer {
            CoreGlobal.core(for: sender)?.remove(joint: self)
        }
        
        self.senderReference = nil
        self.core = nil
        self.handlers = []
        self.subJoints = []
    }
}
