//
//  Joint.swift
//

import Foundation

public protocol JointClass: class {}

internal protocol AnyJoint: JointClass {
    func broadcast()
    func invalidate()
}

internal class Joint<Sender: Sendable> {
    internal typealias Value = Sender.SendValue
    
    internal weak var sender: Sender?
    internal var handlers: [Any] = []
    internal var subJoints: [AnyJoint] = []
    private var core: AnySenderCore?
    
    internal init(sender: Sender, core: AnySenderCore) {
        self.sender = sender
        self.core = core
    }
    
    deinit {
        self.sender?.getCore()?.remove(joint: self)
    }
    
    internal func call(first value: Value) {
        if let handler = self.handlers.first as? (Value) -> Void {
            handler(value)
        }
    }
}

extension Joint: AnyJoint {
    internal func broadcast() {
        if let canFetch = self.sender?.canFetch(), canFetch {
            self.sender?.fetch(for: self)
        }
        
        for subJoint in self.subJoints {
            subJoint.broadcast()
        }
    }
    
    internal func invalidate() {
        for subJoint in self.subJoints {
            subJoint.invalidate()
        }
        
        self.sender?.getCore()?.remove(joint: self)
        self.sender = nil
        self.core = nil
        self.handlers = []
        self.subJoints = []
    }
}
