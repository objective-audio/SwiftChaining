//
//  Joint.swift
//

import Foundation

public protocol AnyJoint: class {
    func broadcast()
    func invalidate()
}

public class Joint<Sender: Sendable> {
    typealias Value = Sender.SendValue
    
    public weak var sender: Sender?
    public var handlers: [Any] = []
    public var subJoints: [AnyJoint] = []
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
    public func broadcast() {
        self.sender?.fetch(for: self)
        
        for subJoint in self.subJoints {
            subJoint.broadcast()
        }
    }
    
    public func invalidate() {
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
