//
//  Observer.swift
//

import Foundation

public protocol AnyObserver: class {
    func invalidate()
}

public class Observer<Sender: Sendable> {
    private let joint: Joint<Sender>
    
    init(joint: Joint<Sender>) {
        self.joint = joint
    }
    
    public func invalidate() {
        self.joint.invalidate()
    }
}

extension Observer: AnyObserver {
}

extension Observer where Sender: Fetchable {
    func broadcast() {
        self.joint.broadcast()
    }
}

public class ObserverPool {
    fileprivate var observers: [AnyObserver] = []
    
    public init() {}
    
    deinit {
        self.invalidate()
    }
    
    public func add(_ observer: AnyObserver) {
        self.observers.append(observer)
    }
    
    public func remove(_ observer: AnyObserver) {
        let removing = ObjectIdentifier(observer)
        
        self.observers = self.observers.filter {
            if ObjectIdentifier($0) == removing {
                $0.invalidate()
                return false
            } else {
                return true
            }
        }
    }
    
    public func invalidate() {
        for observer in self.observers {
            observer.invalidate()
        }
        self.observers = []
    }
}

extension ObserverPool {
    static public func += (left: inout ObserverPool, right: AnyObserver) {
        left.add(right)
    }
    
    static public func -= (left: inout ObserverPool, right: AnyObserver) {
        left.remove(right)
    }
}
