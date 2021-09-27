//
//  Joint.swift
//

import Foundation

public protocol JointClass: AnyObject {}

internal protocol AnyJoint: JointClass {
    var handlers: [Any] { get }
    func fetch()
    func invalidate()
    func checkAllReferencesRetained() -> Bool
}

internal typealias JointHandler<T> = (T, AnyJoint) -> Void

internal class Joint<Chainer: Chainable> {
    internal typealias Value = Chainer.ChainValue
    
    internal var chainer: Chainer? { return self.chainerRef?.value }
    private var chainerRef: Reference<Chainer>?
    internal private(set) var handlers: [Any] = []
    private var subJoints: [AnyJoint] = []
    private var core: AnyCore?
    private var references: [AnyReference] = []
    private let lock = NSLock()
    
    internal init(chainer: Reference<Chainer>, core: AnyCore) {
        self.chainerRef = chainer
        self.core = core
    }
    
    deinit {
        if let chainer = self.chainer {
            CoreGlobal.core(for: chainer)?.remove(joint: self)
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
    
    internal func appendReference(_ reference: AnyReference) {
        self.references.append(reference)
    }
    
    internal func checkAllReferencesRetained() -> Bool {
        defer {
            self.references = []
        }
        guard self.references.allSatisfy({ $0.hasValue }) else {
            return false
        }
        return self.subJoints.allSatisfy { $0.checkAllReferencesRetained() }
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
        
        if let chainer = self.chainer {
            CoreGlobal.core(for: chainer)?.remove(joint: self)
        }
        
        self.chainerRef = nil
        self.core = nil
        self.handlers = []
        self.subJoints = []
    }
}
