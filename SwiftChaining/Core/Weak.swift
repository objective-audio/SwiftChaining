//
//  Weak.swift
//

import Foundation

public enum Reference<T: AnyObject> {
    case strong(_: T)
    case weak(_: Weak<T>)
    
    var value: T? {
        switch self {
        case .strong(let value):
            return value
        case .weak(let weak):
            return weak.value
        }
    }
}

public struct Weak<T: AnyObject> {
    internal private(set) weak var value: T?
    internal let id: ObjectIdentifier

    internal init(_ value: T) {
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
