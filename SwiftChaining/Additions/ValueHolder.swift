//
//  ValueHolder.swift
//

import Foundation

public protocol ValueReadable {
    associatedtype Val
    var value: Val { get }
}

final public class ValueHolder<T> {
    public private(set) var raw: T
    
    public init(_ initial: T) {
        self.raw = initial
    }
    
    public var value: T {
        set {
            self.raw = newValue
            self.broadcast(value: newValue)
        }
        get { return self.raw }
    }
}

extension ValueHolder: ValueReadable {}

extension ValueHolder: Fetchable {
    public typealias SendValue = T
    
    public func fetchedValue() -> T {
        return self.value
    }
}

extension ValueHolder where T: Equatable {
    public var value: T {
        set {
            if self.raw != newValue {
                self.raw = newValue
                self.broadcast(value: newValue)
            }
        }
        get { return self.raw }
    }
}

extension ValueHolder: Receivable {
    public func receive(value: T) {
        self.value = value
    }
}

extension ValueHolder: Equatable where T: Equatable {
    public static func == (lhs: ValueHolder, rhs: ValueHolder) -> Bool {
        return lhs.raw == rhs.raw
    }
}
