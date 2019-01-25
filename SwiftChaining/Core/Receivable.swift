//
//  Receivable.swift
//

import Foundation

public protocol Receivable: class {
    associatedtype ReceiveValue
    
    func receive(value: ReceiveValue)
}
