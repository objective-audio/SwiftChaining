//
//  Weak.swift
//

import Foundation

internal class Weak<T: AnyObject> {
    internal private(set) weak var value: T?
    internal let id: ObjectIdentifier

    internal init(_ value: T) {
        self.value = value
        self.id = ObjectIdentifier(value)
    }
}

extension Weak: Hashable {
    internal var hashValue: Int {
        return id.hashValue
    }
    
    internal static func == (lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        return lhs.id == rhs.id
    }
}
