//
//  Notifier.swift
//

import Foundation

final public class Notifier<T> {
    public init() {}
}

extension Notifier: Sendable {
    public typealias ChainValue = T
    
    public func notify(value: T) {
        self.broadcast(value: value)
    }
}

extension Notifier: Receivable {
    public typealias ReceiveValue = T
    
    public func receive(value: T) {
        self.broadcast(value: value)
    }
}

extension Notifier where T == Void {
    public func notify() {
        self.broadcast(value: ())
    }
}
