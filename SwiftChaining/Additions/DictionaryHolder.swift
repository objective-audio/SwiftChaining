//
//  DictionaryHolder.swift
//

import Foundation

public typealias DictionaryHolder<Key: Hashable, Value> = DictionaryHolderImpl<Key, Value, Value>
public typealias RelayableDictionaryHolder<Key: Hashable, Value: Sendable> = DictionaryHolderImpl<Key, Value, Value.SendValue>

final public class DictionaryHolderImpl<Key: Hashable, Value, Relay> {
    public private(set) var rawDictionary: [Key: Value] = [:]
    
    public var count: Int { return self.rawDictionary.count }
    
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
    
    public init() {}
    
    public convenience init(_ dictionary: [Key: Value]) {
        self.init()
        
        self.set(dictionary)
    }
    
    public var capacity: Int {
        return self.rawDictionary.capacity
    }
    
    public func set(_ dictionary: [Key: Value]) {
        self.set(dictionary, relaying: nil)
    }
    
    public func replace(key: Key, value: Value) {
        self.replace(key: key, value: value, relaying: nil)
    }
    
    public func insert(key: Key, value: Value) {
        self.insert(key: key, value: value, relaying: nil)
    }
    
    @discardableResult
    public func removeValue(forKey key: Key) -> Value? {
        if let wrapper = self.observerDictionary.removeValue(forKey: key) {
            if let observer = wrapper.observer {
                observer.invalidate()
            }
        }
        
        if let value = self.rawDictionary.removeValue(forKey: key) {
            self.broadcast(value: .removed(key: key, value: value))
            
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

        self.broadcast(value: .any([:]))
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
    private typealias RelayingHandler = (Key, Value) -> AnyObserver
    
    private func insert(key: Key, value: Value, relaying: RelayingHandler?) {
        guard self.rawDictionary[key] == nil || self.observerDictionary[key] == nil else {
            fatalError()
        }
        
        self.observerDictionary[key] = ObserverWrapper(observer: relaying?(key, value))
        self.rawDictionary[key] = value
        
        self.broadcast(value: .inserted(key: key, value: value))
    }
    
    private func replace(key: Key, value: Value, relaying: RelayingHandler?) {
        guard self.rawDictionary[key] != nil || self.observerDictionary[key] != nil else {
            fatalError()
        }
        
        self.observerDictionary[key] = ObserverWrapper(observer: relaying?(key, value))
        self.rawDictionary[key] = value
        
        self.broadcast(value: .replaced(key: key, value: value))
    }
    
    private func set(_ dictionary: [Key: Value], relaying: RelayingHandler?) {
        for (_, value) in self.observerDictionary {
            if let observer = value.observer {
                observer.invalidate()
            }
        }
        
        self.observerDictionary = [:]
        self.rawDictionary = [:]
        
        for (key, value) in dictionary {
            self.observerDictionary[key] = ObserverWrapper(observer: relaying?(key, value))
        }
        self.rawDictionary = dictionary
        
        self.broadcast(value: .any(dictionary))
    }
}

extension DictionaryHolderImpl: Fetchable {
    public typealias SendValue = Event
    
    public func fetchedValue() -> Event? {
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
        self.set(elements, relaying: self.relaying())
    }

    public func replace(key: Key, value: Value) {
        self.replace(key: key, value: value, relaying: self.relaying())
    }

    public func insert(key: Key, value: Value) {
        self.insert(key: key, value: value, relaying: self.relaying())
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

    private func relaying() -> (RelayingHandler) {
        return { (key: Key, value: Value) in
            value.chain().do({ [weak self] relayedValue in
                if let self = self {
                    self.broadcast(value: .relayed(relayedValue, key: key, value: value))
                }
            }).end()
        }
    }
}
