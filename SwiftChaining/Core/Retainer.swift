//
//  Retainer.swift
//

import Foundation

public struct Retainer<T> {
    internal let object: T
}

extension Retainer where T: Sendable {
    public func chain() -> T.SenderChain {
        return object.chain(retained: true)
    }
}
