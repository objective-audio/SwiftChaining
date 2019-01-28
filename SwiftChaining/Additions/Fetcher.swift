//
//  Fetcher.swift
//

import Foundation

final public class Fetcher<T> {
    private let fetching: () -> T?
    
    public init(fetching: @escaping () -> T?) {
        self.fetching = fetching
    }
    
    public func broadcast() {
        if let fetched = self.fetchedValue() {
            self.broadcast(value: fetched)
        }
    }
}

extension Fetcher: Fetchable {
    public typealias SendValue = T
    
    public func fetchedValue() -> T? {
        return self.fetching()
    }
}

extension Fetcher: Receivable {
    public func receive(value: T) {
        self.broadcast(value: value)
    }
}
