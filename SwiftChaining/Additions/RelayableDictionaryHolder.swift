//
//  RelayableDictionaryHolder.swift
//

import Foundation

final public class RelayableDictionaryHolder<Key: Hashable, Value: Sendable> {
    public private(set) var raw: [Key: Value] = [:]
    
    public var count: Int { return self.raw.count }
    
    public enum Event {
        case fetched([Key: Value])
        case any([Key: Value])
        case inserted(key: Key, value: Value)
        case removed(key: Key, value: Value)
        case replaced(key: Key, value: Value)
        case relayed(Value.SendValue, key: Key, value: Value)
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
        return self.raw.capacity
    }
    
    public func set(_ dictionary: [Key: Value]) {
        for (_, value) in self.observerDictionary {
            if let observer = value.observer {
                observer.invalidate()
            }
        }
        
        self.observerDictionary = [:]
        self.raw = [:]
        
        for (key, value) in dictionary {
            self.observerDictionary[key] = self.relayingWrapper(key: key, value: value)
        }
        self.raw = dictionary
        
        self.broadcast(value: .any(dictionary))
    }
    
    public func replace(key: Key, value: Value) {
        guard self.raw[key] != nil || self.observerDictionary[key] != nil else {
            fatalError()
        }
        
        self.observerDictionary[key] = self.relayingWrapper(key: key, value: value)
        self.raw[key] = value
        
        self.broadcast(value: .replaced(key: key, value: value))
    }
    
    public func insert(key: Key, value: Value) {
        guard self.raw[key] == nil || self.observerDictionary[key] == nil else {
            fatalError()
        }
        
        self.observerDictionary[key] = self.relayingWrapper(key: key, value: value)
        self.raw[key] = value
        
        self.broadcast(value: .inserted(key: key, value: value))
    }
    
    @discardableResult
    public func removeValue(forKey key: Key) -> Value? {
        if let wrapper = self.observerDictionary.removeValue(forKey: key) {
            if let observer = wrapper.observer {
                observer.invalidate()
            }
        }
        
        if let value = self.raw.removeValue(forKey: key) {
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
        self.raw.removeAll(keepingCapacity: keepCapacity)
        
        self.broadcast(value: .any([:]))
    }
    
    public func reserveCapacity(_ capacity: Int) {
        self.observerDictionary.reserveCapacity(capacity)
        self.raw.reserveCapacity(capacity)
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return self.raw[key]
        }
        set(value) {
            if let value = value {
                if self.raw[key] == nil {
                    self.insert(key: key, value: value)
                } else {
                    self.replace(key: key, value: value)
                }
            } else {
                self.removeValue(forKey: key)
            }
        }
    }
    
    private func relayingWrapper(key: Key, value: Value) -> ObserverWrapper {
        let observer = value.chain().do({ [weak self] relayedValue in
            if let self = self {
                self.broadcast(value: .relayed(relayedValue, key: key, value: value))
            }
        }).end()
        return ObserverWrapper(observer: observer)
    }
}

extension RelayableDictionaryHolder: DictionaryReadable {}

extension RelayableDictionaryHolder: Fetchable {
    public typealias SendValue = Event
    
    public func fetchedValue() -> Event? {
        return .fetched(self.raw)
    }
}
