//
//  Holder.swift
//

import Foundation

public class ImmutableHolder<T> {
    public let core = SenderCore<Holder<T>>()
    
    fileprivate init() {}
    
    public func immutableChain() -> Holder<T>.SenderChain {
        return Chain(joint: self.core.addJoint(sender: self as! Holder<T>), handler: { $0 })
    }
}

final public class Holder<T>: ImmutableHolder<T> {
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
    
    public var immutable: ImmutableHolder<T> {
        return self
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
