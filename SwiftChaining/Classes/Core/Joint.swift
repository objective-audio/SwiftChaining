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
    
    init(sender: Sender) {
        self.sender = sender
    }
    
    deinit {
        self.sender?.core.remove(joint: self)
    }
    
    func call(first value: Value) {
        if let handler = self.handlers.first as? (Value) -> Void {
            handler(value)
        }
    }
    
    public func invalidate() {
        for subJoint in self.subJoints {
            subJoint.invalidate()
        }
        
        self.sender?.core.remove(joint: self)
        self.sender = nil
        self.handlers = []
        self.subJoints = []
    }
}

extension Joint: AnyJoint {
    public func broadcast() {
        self.sender?.fetch(for: self)
        
        for subJoint in self.subJoints {
            subJoint.broadcast()
        }
    }
}
