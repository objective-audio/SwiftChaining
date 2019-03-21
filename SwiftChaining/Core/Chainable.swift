//
//  Chainable.swift
//

import Foundation

public protocol Chainable: class {
    associatedtype SendValue
    
    func fetch(for: JointClass)
}

extension Chainable {
}
