//
//  Receivable.swift
//

import Foundation

public typealias Receivable = ValueReceivable & ReceiveReferencable

public protocol ValueReceivable: class {
    associatedtype ReceiveValue
    
    func receive(value: ReceiveValue)
}

public protocol ReceiveReferencable {
    associatedtype ReceiveObject: ValueReceivable = Self
    
    func reference() -> Reference<ReceiveObject>
}

extension ReceiveReferencable where ReceiveObject == Self {
    public func reference() -> Reference<ReceiveObject> {
        return .weak(Weak(self))
    }
}
