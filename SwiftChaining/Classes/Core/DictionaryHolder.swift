//
//  DictionaryHolder.swift
//

import Foundation

public class ImmutableDictionaryHolder<Key: Hashable, Value: Relayable> {
    public let core = SenderCore<DictionaryHolder<Key, Value>>()
    
    fileprivate init() {}
    
    public func chain() -> DictionaryHolder<Key, Value>.SenderChain {
        return Chain(joint: self.core.addJoint(sender: self as! DictionaryHolder<Key, Value>), handler: { $0 })
    }
}

final public class DictionaryHolder<Key: Hashable, Value: Relayable>: ImmutableDictionaryHolder<Key, Value> {
    public enum Event {
        case all([Key: Value])
        case inserted(key: Key, value: Value)
        case removed(key: Key, value: Value)
        case replaced(key: Key, value: Value)
        case relayed(Value.SendValue, key: Key, value: Value)
    }
    
    struct ObserverWrapper {
        var observer: AnyObserver?
        
        init(_ observer: AnyObserver?) {
            self.observer = observer
        }
    }
    
    public private(set) var rawDictionary: [Key: Value] = [:]
    private var observerDictionary: [Key: ObserverWrapper] = [:]
    
    public var count: Int { return self.rawDictionary.count }
    
    public override init() {}
    
    public convenience init(_ dictionary: [Key: Value]) {
        self.init()
        
        self.replace(dictionary)
    }
    
    public func replace(_ dictionary: [Key: Value]) {
        self.replace(dictionary, chaining: nil)
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

        self.core.broadcast(value: .all([:]))
    }
    
    public func reserveCapacity(_ capacity: Int) {
        self.observerDictionary.reserveCapacity(capacity)
        self.rawDictionary.reserveCapacity(capacity)
    }
    
    public var capacity: Int {
        return self.rawDictionary.capacity
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

extension DictionaryHolder /* private */ {
    private typealias ChainingHandler = (Key, Value) -> AnyObserver
    
    private func insert(key: Key, value: Value, chaining: ChainingHandler?) {
        guard self.rawDictionary[key] == nil || self.observerDictionary[key] == nil else {
            fatalError()
        }
        
        self.observerDictionary[key] = ObserverWrapper(chaining?(key, value))
        self.rawDictionary[key] = value
        
        self.core.broadcast(value: .inserted(key: key, value: value))
    }
    
    private func replace(key: Key, value: Value, chaining: ChainingHandler?) {
        guard self.rawDictionary[key] != nil || self.observerDictionary[key] != nil else {
            fatalError()
        }
        
        self.observerDictionary[key] = ObserverWrapper(chaining?(key, value))
        self.rawDictionary[key] = value
        
        self.core.broadcast(value: .replaced(key: key, value: value))
    }
    
    private func replace(_ dictionary: [Key: Value], chaining: ChainingHandler?) {
        for (_, value) in self.observerDictionary {
            if let observer = value.observer {
                observer.invalidate()
            }
        }
        
        self.observerDictionary = [:]
        self.rawDictionary = [:]
        
        for (key, value) in dictionary {
            self.observerDictionary[key] = ObserverWrapper(chaining?(key, value))
        }
        self.rawDictionary = dictionary
        
        self.core.broadcast(value: .all(dictionary))
    }
}

extension DictionaryHolder: Fetchable {
    public typealias SendValue = Event
    
    public func fetchedValue() -> SendValue {
        return .all(self.rawDictionary)
    }
}

// MARK: - Value: Sendable

extension DictionaryHolder where Value: Sendable {
    public convenience init(_ dictionary: [Key: Value]) {
        self.init()

        self.replace(dictionary)
    }

    public func replace(_ elements: [Key: Value]) {
        self.replace(elements, chaining: self.chaining())
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
