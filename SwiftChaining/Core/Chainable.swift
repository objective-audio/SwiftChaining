//
//  Chainable.swift
//

import Foundation

public protocol Chainable: class {
    associatedtype SendValue
    typealias SenderChain = Chain<SendValue, Self>
    
    func fetch(for: JointClass)
}

extension Chainable {
}
