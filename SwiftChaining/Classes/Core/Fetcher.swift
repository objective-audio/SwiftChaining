//
//  Fetcher.swift
//

import Foundation

final public class Fetcher<T> {
    public let core = SenderCore<Fetcher>()
    
    public let fetching: (() -> SendValue)
    
    public var value: SendValue {
        return self.fetchedValue()
    }
    
    public init(fetching: @escaping () -> SendValue) {
        self.fetching = fetching
    }
    
    public func broadcast() {
        self.broadcast(value: self.fetchedValue())
    }
}

extension Fetcher: Fetchable {
    public typealias SendValue = T
    
    public func fetchedValue() -> SendValue {
        return self.fetching()
    }
}

extension Fetcher: Receivable {
    public typealias ReceiveValue = Void
    
    public func receive(value: Void) {
        self.broadcast()
    }
}
