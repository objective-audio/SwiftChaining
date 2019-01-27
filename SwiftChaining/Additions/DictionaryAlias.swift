//
//  DictionaryAlias.swift
//

import Foundation

public class DictionaryAlias<Key: Hashable, Value> {
    private let holder: DictionaryHolder<Key, Value>
    
    public var rawDictionary: [Key: Value] { return self.holder.rawDictionary }
    
    public var count: Int { return self.holder.count }
    
    public init(_ holder: DictionaryHolder<Key, Value>) {
        self.holder = holder
    }
    
    public var capacity: Int {
        return self.holder.capacity
    }
    
    public func chain() -> DictionaryHolder<Key, Value>.SenderChain {
        return self.holder.chain()
    }
}

public class RelayableDictionaryAlias<Key: Hashable, Value: Sendable> {
    private let holder: RelayableDictionaryHolder<Key, Value>
    
    public var rawDictionary: [Key: Value] { return self.holder.rawDictionary }
    
    public var count: Int { return self.holder.count }
    
    public init(_ holder: RelayableDictionaryHolder<Key, Value>) {
        self.holder = holder
    }
    
    public var capacity: Int {
        return self.holder.capacity
    }
    
    public func chain() -> RelayableDictionaryHolder<Key, Value>.SenderChain {
        return self.holder.chain()
    }
}
