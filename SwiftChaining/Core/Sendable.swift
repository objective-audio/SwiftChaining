//
//  Sendable.swift
//

import Foundation

public protocol Sendable: Chainable {
}

extension Sendable {
    public func broadcast(value: SendValue) {
        CoreGlobal.core(for: self)?.broadcast(value: value)
    }
}
