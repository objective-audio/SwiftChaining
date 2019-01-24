//
//  Notifier.swift
//

import Foundation

final public class Notifier<T> {
    private let lock = NSLock()
    
    public init() {}
    
    private func lockedSend(value: SendValue) {
        if self.lock.try() {
            self.broadcast(value: value)
            self.lock.unlock()
        }
    }
}

extension Notifier: Sendable {
    public typealias SendValue = T
    
    public func notify(value: SendValue) {
        self.lockedSend(value: value)
    }
}

extension Notifier: Receivable {
    public func receive(value: SendValue) {
        self.lockedSend(value: value)
    }
}

extension Notifier where T == Void {
    public func notify() {
        self.lockedSend(value: ())
    }
}
