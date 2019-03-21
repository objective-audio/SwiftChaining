//
//  Observer.swift
//

import Foundation

public protocol AnyObserver: class {
    func invalidate()
}

public class Observer<Sender: Chainable> {
    private let joint: Joint<Sender>
    
    internal init(joint: Joint<Sender>) {
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

extension Observer where Sender: Fetchable {
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
