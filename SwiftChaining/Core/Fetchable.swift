//
//  Fetchable.swift
//

import Foundation

public protocol Fetchable: Sendable {
    func fetchedValue() -> SendValue?
}

extension Fetchable {
    public func fetch(for joint: AnyJoint) {
        if let fetched = self.fetchedValue() {
            self.getCore()?.send(value: fetched, to: joint)
        }
    }
}
