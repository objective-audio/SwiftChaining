//
//  ReadOnlyDictionaryHolder.swift
//

import Foundation

public typealias ReadOnlyDictionaryHolder<Key: Hashable, Value> = ReadOnlyDictionaryHolderImpl<Key, Value, Value>
public typealias ReadOnlyRelayableDictionaryHolder<Key: Hashable, Value: Sendable> = ReadOnlyDictionaryHolderImpl<Key, Value, Value.SendValue>

public class ReadOnlyDictionaryHolderImpl<Key: Hashable, Value, Relay> {
    private let holder: DictionaryHolderImpl<Key, Value, Relay>
    
    public var rawDictionary: [Key: Value] { return self.holder.rawDictionary }
    
    public var count: Int { return self.holder.count }
    
    public init(_ holder: DictionaryHolderImpl<Key, Value, Relay>) {
        self.holder = holder
    }
    
    public var capacity: Int {
        return self.holder.capacity
    }
    
    public func chain() -> DictionaryHolderImpl<Key, Value, Relay>.SenderChain {
        return self.holder.chain()
    }
}
