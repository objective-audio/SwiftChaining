//
//  RelayableValueHolder.swift
//

import Foundation

final public class RelayableValueHolder<T: Sendable> {
    public enum Event {
        case fetched(T)
        case current(T)
        case relayed(T.ChainValue)
    }
    
    public private(set) var rawValue: T
    private var observer: AnyObserver?
    
    public init(_ initial: T) {
        self.rawValue = initial
        self.relaying()
    }
    
    public var value: T {
        set {
            self.rawValue = newValue
            self.relaying()
            self.broadcast(value: .current(newValue))
        }
        get { return self.rawValue }
    }
    
    private func relaying() {
        self.observer = self.rawValue.chain().do { [weak self] value in self?.broadcast(value: .relayed(value)) }.end()
    }
}

extension RelayableValueHolder: Syncable {
    public typealias ChainValue = Event
    
    public func fetchedValue() -> Event {
        return .fetched(self.value)
    }
}

extension RelayableValueHolder where T: Equatable {
    public var value: T {
        set {
            if self.rawValue != newValue {
                self.rawValue = newValue
                self.relaying()
                self.broadcast(value: .current(newValue))
            }
        }
        get { return self.rawValue }
    }
}

extension RelayableValueHolder: Receivable {
    public typealias ReceiveValue = T
    
    public func receive(value: T) {
        self.value = value
    }
}

extension RelayableValueHolder: Equatable where T: Equatable {
    public static func == (lhs: RelayableValueHolder, rhs: RelayableValueHolder) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension RelayableValueHolder.Event: Equatable where T: Equatable, T.ChainValue: Equatable {
    public static func == (lhs: RelayableValueHolder.Event, rhs: RelayableValueHolder.Event) -> Bool {
        switch (lhs, rhs) {
        case (.fetched(let lhsFetched), .fetched(let rhsFetched)):
            return lhsFetched == rhsFetched
        case (.current(let lhsCurrent), .current(let rhsCurrent)):
            return lhsCurrent == rhsCurrent
        case (.relayed(let lhsRelayed), .relayed(let rhsRelayed)):
            return lhsRelayed == rhsRelayed
        default:
            return false
        }
    }
}
