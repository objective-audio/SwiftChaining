//
//  Sendable.swift
//

import Foundation

public protocol Sendable: Chainable {
}

extension Sendable {
    public func broadcast(value: ChainValue) {
        CoreGlobal.core(for: self)?.broadcast(value: value)
    }
}
