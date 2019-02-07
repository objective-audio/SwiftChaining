//
//  Fetchable.swift
//

import Foundation

public protocol Fetchable: Sendable {
    func fetchedValue() -> SendValue
}

extension Fetchable {
    public func fetch(for joint: JointClass) {
        self.getCore()?.send(value: self.fetchedValue(), to: joint)
    }
}
