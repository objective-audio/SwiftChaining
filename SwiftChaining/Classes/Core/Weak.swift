//
//  Weak.swift
//

import Foundation

public class Weak<T: AnyObject> {
    private(set) weak var value: T?
    let id: ObjectIdentifier

    init(_ value: T) {
        self.value = value
        self.id = ObjectIdentifier(value)
    }
}

extension Weak: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func == (lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        return lhs.id == rhs.id
    }
}
