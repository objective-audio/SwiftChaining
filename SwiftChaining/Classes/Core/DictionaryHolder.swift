//
//  DictionaryHolder.swift
//

import Foundation

public typealias DictionaryHolder<Key: Hashable, Value> = DictionaryHolderImpl<Key, Value, Value>
public typealias RelayableDictionaryHolder<Key: Hashable, Value: Sendable> = DictionaryHolderImpl<Key, Value, Value.SendValue>
public typealias ReadOnlyDictionaryHolder<Key: Hashable, Value> = ReadOnlyDictionaryHolderImpl<Key, Value, Value>
public typealias ReadOnlyRelayableDictionaryHolder<Key: Hashable, Value: Sendable> = ReadOnlyDictionaryHolderImpl<Key, Value, Value.SendValue>

public class ReadOnlyDictionaryHolderImpl<Key: Hashable, Value, Relay> {
    public let core = SenderCore<DictionaryHolderImpl<Key, Value, Relay>>()
    
    public fileprivate(set) var rawDictionary: [Key: Value] = [:]
    
    public var count: Int { return self.rawDictionary.count }
    
    fileprivate init() {}
    
    public var capacity: Int {
        return self.rawDictionary.capacity
    }
    
    public func chain() -> DictionaryHolderImpl<Key, Value, Relay>.SenderChain {
        return Chain(joint: self.core.addJoint(sender: self as! DictionaryHolderImpl<Key, Value, Relay>), handler: { $0 })
    }
}

final public class DictionaryHolderImpl<Key: Hashable, Value, Relay>: ReadOnlyDictionaryHolderImpl<Key, Value, Relay> {
    public enum Event {
        case fetched([Key: Value])
        case any([Key: Value])
        case inserted(key: Key, value: Value)
        case removed(key: Key, value: Value)
        case replaced(key: Key, value: Value)
        case relayed(Relay, key: Key, value: Value)
    }
    
    private struct ObserverWrapper {
        var observer: AnyObserver?
    }
    
    private var observerDictionary: [Key: ObserverWrapper] = [:]
    
    public override init() {}
    
    public convenience init(_ dictionary: [Key: Value]) {
        self.init()
        
        self.set(dictionary)
    }
    
    public func set(_ dictionary: [Key: Value]) {
        self.set(dictionary, chaining: nil)
    }
    
    public func replace(key: Key, value: Value) {
        self.replace(key: key, value: value, chaining: nil)
    }
    
    public func insert(key: Key, value: Value) {
        self.insert(key: key, value: value, chaining: nil)
    }
    
    @discardableResult
    public func removeValue(forKey key: Key) -> Value? {
        if let wrapper = self.observerDictionary.removeValue(forKey: key) {
            if let observer = wrapper.observer {
                observer.invalidate()
            }
        }
        
        if let value = self.rawDictionary.removeValue(forKey: key) {
            self.core.broadcast(value: .removed(key: key, value: value))
            
            return value
        } else {
            return nil
        }
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        for (_, wrapper) in self.observerDictionary {
            if let observer = wrapper.observer {
                observer.invalidate()
            }
        }

        self.observerDictionary.removeAll(keepingCapacity: keepCapacity)
        self.rawDictionary.removeAll(keepingCapacity: keepCapacity)

        self.core.broadcast(value: .any([:]))
    }
    
    public func reserveCapacity(_ capacity: Int) {
        self.observerDictionary.reserveCapacity(capacity)
        self.rawDictionary.reserveCapacity(capacity)
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return self.rawDictionary[key]
        }
        set(value) {
            if let value = value {
                if self.rawDictionary[key] == nil {
                    self.insert(key: key, value: value)
                } else {
                    self.replace(key: key, value: value)
                }
            } else {
                self.removeValue(forKey: key)
            }
        }
    }
}

extension DictionaryHolderImpl /* private */ {
    private typealias ChainingHandler = (Key, Value) -> AnyObserver
    
    private func insert(key: Key, value: Value, chaining: ChainingHandler?) {
        guard self.rawDictionary[key] == nil || self.observerDictionary[key] == nil else {
            fatalError()
        }
        
        self.observerDictionary[key] = ObserverWrapper(observer: chaining?(key, value))
        self.rawDictionary[key] = value
        
        self.core.broadcast(value: .inserted(key: key, value: value))
    }
    
    private func replace(key: Key, value: Value, chaining: ChainingHandler?) {
        guard self.rawDictionary[key] != nil || self.observerDictionary[key] != nil else {
            fatalError()
        }
        
        self.observerDictionary[key] = ObserverWrapper(observer: chaining?(key, value))
        self.rawDictionary[key] = value
        
        self.core.broadcast(value: .replaced(key: key, value: value))
    }
    
    private func set(_ dictionary: [Key: Value], chaining: ChainingHandler?) {
        for (_, value) in self.observerDictionary {
            if let observer = value.observer {
                observer.invalidate()
            }
        }
        
        self.observerDictionary = [:]
        self.rawDictionary = [:]
        
        for (key, value) in dictionary {
            self.observerDictionary[key] = ObserverWrapper(observer: chaining?(key, value))
        }
        self.rawDictionary = dictionary
        
        self.core.broadcast(value: .any(dictionary))
    }
}

extension DictionaryHolderImpl: Fetchable {
    public typealias SendValue = Event
    
    public func fetchedValue() -> SendValue? {
        return .fetched(self.rawDictionary)
    }
}

// MARK: - Value: Sendable

extension DictionaryHolderImpl where Value: Sendable, Relay == Value.SendValue {
    public convenience init(_ dictionary: [Key: Value]) {
        self.init()

        self.set(dictionary)
    }

    public func set(_ elements: [Key: Value]) {
        self.set(elements, chaining: self.chaining())
    }

    public func replace(key: Key, value: Value) {
        self.replace(key: key, value: value, chaining: self.chaining())
    }

    public func insert(key: Key, value: Value) {
        self.insert(key: key, value: value, chaining: self.chaining())
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return self.rawDictionary[key]
        }
        set(value) {
            if let value = value {
                if self.rawDictionary[key] == nil {
                    self.insert(key: key, value: value)
                } else {
                    self.replace(key: key, value: value)
                }
            } else {
                self.removeValue(forKey: key)
            }
        }
    }

    private func chaining() -> (ChainingHandler) {
        return { (key: Key, value: Value) in
            value.chain().do({ [weak self] relayedValue in
                if let sself = self {
                    sself.core.broadcast(value: .relayed(relayedValue, key: key, value: value))
                }
            }).end()
        }
    }
}
