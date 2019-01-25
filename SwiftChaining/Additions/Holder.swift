//
//  Holder.swift
//

import Foundation

final public class Holder<T> {
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

extension Holder: Fetchable {
    public typealias SendValue = T
    
    public func fetchedValue() -> T? {
        return self.value
    }
}

extension Holder where T: Equatable {
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

extension Holder: Receivable {
    public func receive(value: T) {
        self.value = value
    }
}

extension Holder: Equatable where T: Equatable {
    public static func == (lhs: Holder, rhs: Holder) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
