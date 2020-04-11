//
//  Chain.swift
//

import Foundation

public protocol ChainableProtocol {
    associatedtype ChainValue
}

public protocol SendableProtocol: ChainableProtocol {}
public protocol FetchableProtocol: ChainableProtocol {}
public protocol SyncableProtocol: SendableProtocol & FetchableProtocol {}

public struct Sendable<T>: SendableProtocol {
    public typealias ChainValue = T
}

public struct Fetchable<T>: FetchableProtocol {
    public typealias ChainValue = T
}

public struct Syncable<T>: SyncableProtocol {
    public typealias ChainValue = T
}

final public class Chain<Out, ChainType: ChainableProtocol> {
    private var joint: Joint<ChainType>?
    
    internal init(joint: Joint<ChainType>) {
        precondition(joint.chainer != nil, "Chainer must be retained while chaining.")
        
        self.joint = joint
    }
    
    internal func pullJoint() -> Joint<ChainType>? {
        defer { self.joint = nil }
        return self.joint
    }
}

public typealias FirstChain<ChainType: ChainableProtocol> = Chain<ChainType.ChainValue, ChainType>
