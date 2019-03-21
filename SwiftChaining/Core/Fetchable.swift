//
//  Fetchable.swift
//

import Foundation

public protocol Fetchable: Sendable {
    func canFetch() -> Bool
    func fetchedValue() -> ChainValue
}

extension Fetchable {
    public func canFetch() -> Bool {
        return true
    }
    
    public func fetch(for joint: JointClass) {
        if self.canFetch() {
            CoreGlobal.core(for: self)?.send(value: self.fetchedValue(), to: joint)
        }
    }
}
