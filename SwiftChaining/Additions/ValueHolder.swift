//
//  ValueHolder.swift
//

import Foundation

public protocol ValueReadable {
    associatedtype Val
    var value: Val { get }
}

final public class ValueHolder<T> {
    public private(set) var rawValue: T
    private let lock = NSLock()
    
    public init(_ initial: T) {
        self.rawValue = initial
    }
    
    public var value: T {
        set {
            if self.lock.try() {
                self.rawValue = newValue
                self.broadcast(value: newValue)
                self.lock.unlock()
            }
        }
        get { return self.rawValue }
    }
}

extension ValueHolder: ValueReadable {}

extension ValueHolder: Fetchable {
    public typealias SendValue = T
    
    public func fetchedValue() -> T? {
        return self.value
    }
}

extension ValueHolder where T: Equatable {
    public var value: T {
        set {
            if self.lock.try() {
                if self.rawValue != newValue {
                    self.rawValue = newValue
                    self.broadcast(value: newValue)
                }
                self.lock.unlock()
            }
        }
        get { return self.rawValue }
    }
}

extension ValueHolder: Receivable {
    public func receive(value: T) {
        self.value = value
    }
}

extension ValueHolder: Equatable where T: Equatable {
    public static func == (lhs: ValueHolder, rhs: ValueHolder) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
