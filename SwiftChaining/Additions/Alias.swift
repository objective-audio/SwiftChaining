//
//  Alias.swift
//

import Foundation

public struct Alias<T: Sendable> {
    private var sender: T
    
    public init(_ sender: T) {
        self.sender = sender
    }
    
    public func chain() -> T.SenderChain {
        return self.sender.chain()
    }
}

extension Alias: HolderProtocol where T: HolderProtocol {
    public typealias Val = T.Val
    
    public var value: T.Val { return self.sender.value }
}

extension Alias: ArrayProtocol where T: ArrayProtocol {
    public typealias Element = T.Element
    
    public var rawArray: [T.Element] { return self.sender.rawArray }
}

extension Alias: DictionaryProtocol where T: DictionaryProtocol {
    public typealias Key = T.Key
    public typealias Value = T.Value

    public var rawDictionary: [Key: Value] { return self.sender.rawDictionary }
}
