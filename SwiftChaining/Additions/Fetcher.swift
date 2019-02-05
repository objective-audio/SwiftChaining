//
//  Fetcher.swift
//

import Foundation

final public class Fetcher<T> {
    private let fetching: () -> T
    
    public init(fetching: @escaping () -> T) {
        self.fetching = fetching
    }
    
    public func broadcast() {
        self.broadcast(value: self.fetchedValue())
    }
}

extension Fetcher: Fetchable {
    public typealias SendValue = T
    
    public func fetchedValue() -> T {
        return self.fetching()
    }
}

extension Fetcher: Receivable {
    public func receive(value: T) {
        self.broadcast(value: value)
    }
}
