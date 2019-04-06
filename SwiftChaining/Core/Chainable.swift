//
//  Chainable.swift
//

import Foundation

public protocol AnyChainable: class {
    func fetch(for: JointClass)
}

public protocol Chainable: AnyChainable {
    associatedtype ChainType: ChainableProtocol
    typealias ChainValue = ChainType.ChainValue
    
    func canFetch() -> Bool
    func fetchedValue() -> ChainValue
}

extension Chainable {
    public func retain() -> Retainer<Self> {
        return Retainer(object: self)
    }
    
    public func chain() -> FirstChain<ChainType> {
        return CoreGlobal.makeChain(chainer: self, retained: false)
    }
    
    public func fetch(for: JointClass) {}
    public func canFetch() -> Bool { fatalError() }
    public func fetchedValue() -> ChainValue {
        fatalError("Fetcher must be overridden fetchedValue.")
    }
}

extension Chainable where ChainType: SendableProtocol {
    public func broadcast(value: ChainValue) {
        if let core = CoreGlobal.core(for: self) as? Core<ChainType> {
            core.broadcast(value: value)
        }
    }
}

extension Chainable where ChainType: FetchableProtocol {
    public func canFetch() -> Bool { return true }
    
    public func fetch(for joint: JointClass) {
        if self.canFetch() {
            if let core = CoreGlobal.core(for: self) as? Core<ChainType> {
                core.send(value: self.fetchedValue(), to: joint)
            }
        }
    }
}
