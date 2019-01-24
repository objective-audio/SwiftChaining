//
//  RelayableHolder.swift
//

import Foundation

final public class RelayableHolder<T: Sendable> {
    public enum Event {
        case current(T)
        case relayed(T.SendValue)
    }
    
    public private(set) var rawValue: T
    private let lock = NSLock()
    private var observer: AnyObserver?
    
    public init(_ initial: T) {
        self.rawValue = initial
        self.relaying()
    }
    
    public var value: T {
        set {
            if self.lock.try() {
                self.rawValue = newValue
                self.relaying()
                self.broadcast(value: .current(newValue))
                self.lock.unlock()
            }
        }
        get { return self.rawValue }
    }
    
    private func relaying() {
        self.observer = self.rawValue.chain().do { [weak self] value in self?.broadcast(value: .relayed(value)) }.end()
    }
}

extension RelayableHolder: Fetchable {
    public typealias SendValue = Event
    
    public func fetchedValue() -> SendValue? {
        return .current(self.value)
    }
}

extension RelayableHolder where T: Equatable {
    public var value: T {
        set {
            if self.lock.try() {
                if self.rawValue != newValue {
                    self.rawValue = newValue
                    self.relaying()
                    self.broadcast(value: .current(newValue))
                }
                self.lock.unlock()
            }
        }
        get { return self.rawValue }
    }
}

extension RelayableHolder: Receivable {
    public func receive(value: T) {
        self.value = value
    }
}

extension RelayableHolder: Equatable where T: Equatable {
    public static func == (lhs: RelayableHolder, rhs: RelayableHolder) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension RelayableHolder.Event: Equatable where T: Equatable, T.SendValue: Equatable {
    public static func == (lhs: RelayableHolder.Event, rhs: RelayableHolder.Event) -> Bool {
        switch (lhs, rhs) {
        case (.current(let lhsCurrent), .current(let rhsCurrent)):
            return lhsCurrent == rhsCurrent
        case (.relayed(let lhsRelayed), .relayed(let rhsRelayed)):
            return lhsRelayed == rhsRelayed
        default:
            return false
        }
    }
}
