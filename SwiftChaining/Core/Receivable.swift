//
//  Receivable.swift
//

import Foundation

public protocol AnyReceivable: class {
}

public protocol Receivable: AnyReceivable {
    associatedtype ReceiveValue
    
    func receive(value: ReceiveValue)
}
