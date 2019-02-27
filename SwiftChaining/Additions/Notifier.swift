//
//  Notifier.swift
//

import Foundation

final public class Notifier<T> {
    public init() {}
    
    private func lockedSend(value: T) {
        self.broadcast(value: value)
    }
}

extension Notifier: Sendable {
    public typealias SendValue = T
    
    public func notify(value: T) {
        self.lockedSend(value: value)
    }
}

extension Notifier: Receivable {
    public func receive(value: T) {
        self.lockedSend(value: value)
    }
}

extension Notifier where T == Void {
    public func notify() {
        self.lockedSend(value: ())
    }
}
