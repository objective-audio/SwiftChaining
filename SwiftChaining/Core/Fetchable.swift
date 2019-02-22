//
//  Fetchable.swift
//

import Foundation

public protocol Fetchable: Sendable {
    func canFetch() -> Bool
    func fetchedValue() -> SendValue
}

extension Fetchable {
    public func canFetch() -> Bool {
        return true
    }
    
    public func fetch(for joint: JointClass) {
        if self.canFetch() {
            self.getCore()?.send(value: self.fetchedValue(), to: joint)
        }
    }
}
