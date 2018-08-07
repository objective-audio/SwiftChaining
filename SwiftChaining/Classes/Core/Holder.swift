//
//  Holder.swift
//

import Foundation

final public class Holder<T> {
    public let core = SenderCore<Holder>()
    private let lock = NSLock()
    
    public var value: SendValue {
        set {
            if self.lock.try() {
                self.rawValue = newValue
                self.broadcast(value: newValue)
                self.lock.unlock()
            }
        }
        get { return self.rawValue }
    }
    
    private var rawValue: SendValue
    
    public init(_ initial: T) {
        self.rawValue = initial
    }
}

extension Holder: Fetchable {
    public typealias SendValue = T
    
    public func fetchedValue() -> SendValue {
        return self.value
    }
}

extension Holder where SendValue: Equatable {
    public var value: SendValue {
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
    public func receive(value: SendValue) {
        self.value = value
    }
}

extension Holder: Equatable where T: Equatable {
    public static func == (lhs: Holder, rhs: Holder) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
