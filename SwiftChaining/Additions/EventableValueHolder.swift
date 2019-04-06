//
//  EventableValueHolder.swift
//

import Foundation

final public class EventableValueHolder<T> {
    public enum Event {
        case fetched(T)
        case current(T)
    }
    
    public private(set) var rawValue: T
    
    public init(_ initial: T) {
        self.rawValue = initial
    }
    
    public var value: T {
        set {
            self.rawValue = newValue
            self.broadcast(value: .current(newValue))
        }
        get { return self.rawValue }
    }
}

extension EventableValueHolder: Chainable {
    public typealias ChainType = Syncable<Event>
    
    public func fetchedValue() -> Event {
        return .fetched(self.value)
    }
}

extension EventableValueHolder where T: Equatable {
    public var value: T {
        set {
            if self.rawValue != newValue {
                self.rawValue = newValue
                self.broadcast(value: .current(newValue))
            }
        }
        get { return self.rawValue }
    }
}

extension EventableValueHolder: Receivable {
    public typealias ReceiveValue = T
    
    public func receive(value: T) {
        self.value = value
    }
}

extension EventableValueHolder: Equatable where T: Equatable {
    public static func == (lhs: EventableValueHolder, rhs: EventableValueHolder) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension EventableValueHolder.Event: Equatable where T: Equatable {
    public static func == (lhs: EventableValueHolder.Event, rhs: EventableValueHolder.Event) -> Bool {
        switch (lhs, rhs) {
        case (.fetched(let lhsFetched), .fetched(let rhsFetched)):
            return lhsFetched == rhsFetched
        case (.current(let lhsCurrent), .current(let rhsCurrent)):
            return lhsCurrent == rhsCurrent
        default:
            return false
        }
    }
}
