//
//  ValueHolder.swift
//

import Foundation

public protocol ValueReadable {
    associatedtype Val
    var value: Val { get }
}

extension Alias: ValueReadable where T: ValueReadable {
    public typealias Val = T.Val
    
    public var value: T.Val { return self.sender.value }
}

final public class ValueHolder<T> {
    public private(set) var raw: T
    private let lock = NSLock()
    
    public init(_ initial: T) {
        self.raw = initial
    }
    
    public var value: T {
        set {
            if self.lock.try() {
                self.raw = newValue
                self.broadcast(value: newValue)
                self.lock.unlock()
            }
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
            if self.lock.try() {
                if self.raw != newValue {
                    self.raw = newValue
                    self.broadcast(value: newValue)
                }
                self.lock.unlock()
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
