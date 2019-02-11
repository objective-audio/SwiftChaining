//
//  Fetcher.swift
//

import Foundation

final public class Fetcher<T> {
    private let fetchedValueHandler: () -> T
    private let canFetchHandler: () -> Bool
    
    public convenience init(_ fetchedValueHandler: @escaping () -> T) {
        self.init(fetchedValueHandler, canFetch: { true })
    }
    
    public init(_ fetchedValue: @escaping () -> T, canFetch: (@escaping () -> Bool)) {
        self.fetchedValueHandler = fetchedValue
        self.canFetchHandler = canFetch
    }
    
    public func broadcast() {
        if self.canFetchHandler() {
            self.broadcast(value: self.fetchedValue())
        }
    }
}

extension Fetcher: Fetchable {
    public typealias SendValue = T
    
    public func canFetch() -> Bool {
        return self.canFetchHandler()
    }
    
    public func fetchedValue() -> T {
        return self.fetchedValueHandler()
    }
}

extension Fetcher: Receivable {
    public typealias ReceiveValue = Void
    
    public func receive(value: Void) {
        self.broadcast()
    }
}
