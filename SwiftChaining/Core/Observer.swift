//
//  Observer.swift
//

import Foundation

public protocol AnyObserver: AnyObject {
    func invalidate()
}

public class Observer<Chainer: Chainable> {
    private let joint: Joint<Chainer>
    
    internal init(joint: Joint<Chainer>) {
        precondition(joint.checkAllReferencesRetained(), "Chainer must be retained while chaining.")
        
        self.joint = joint
    }
    
    deinit {
        self.invalidate()
    }
    
    public func addTo(_ pool: ObserverPool) {
        pool.add(self)
    }
    
    public func invalidate() {
        self.joint.invalidate()
    }
}

extension Observer: AnyObserver {
}

extension Observer where Chainer: Fetchable {
    internal func fetch() {
        self.joint.fetch()
    }
}

public class ObserverPool {
    private var observers: [AnyObserver] = []
    
    public init() {}
    
    deinit {
        self.invalidate()
    }
    
    public func add(_ observer: AnyObserver) {
        self.observers.append(observer)
    }
    
    public func remove(_ observer: AnyObserver) {
        let removing = ObjectIdentifier(observer)
        self.observers.removeAll { ObjectIdentifier($0) == removing }
    }
}

extension ObserverPool: AnyObserver {
    public func invalidate() {
        for observer in self.observers {
            observer.invalidate()
        }
        self.observers = []
    }
}
