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
    
    private typealias ValuePair = (value: Value, observer: AnyObserver?)
    
    public var rawDictionary: [Key: Value] { return self.pairDictionary.mapValues { $0.value } }
    private var pairDictionary: [Key: ValuePair] = [:]
    
    public var count: Int { return self.pairDictionary.count }
    
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
        if let pair = self.pairDictionary.removeValue(forKey: key) {
            if let observer = pair.observer {
                observer.invalidate()
            }
            
            self.core.broadcast(value: .removed(key: key, value: pair.value))
            
            return pair.value
        } else {
            return nil
        }
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        for (_, pair) in self.pairDictionary {
            if let observer = pair.observer {
                observer.invalidate()
            }
        }

        self.pairDictionary.removeAll(keepingCapacity: keepCapacity)

        self.core.broadcast(value: .all([:]))
    }
    
    public func reserveCapacity(_ capacity: Int) {
        self.pairDictionary.reserveCapacity(capacity)
    }
    
    public var capacity: Int {
        return self.pairDictionary.capacity
    }
    
    public subscript(key: Key) -> Value? {
        get {
            if let value = self.pairDictionary[key] {
                return value.value
            } else {
                return nil
            }
        }
        set(value) {
            if let value = value {
                if self.pairDictionary[key] == nil {
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
    private func insert(key: Key, value: Value, chaining: ((Key, Value) -> AnyObserver)?) {
        guard self.pairDictionary[key] == nil else {
            fatalError()
        }
        
        self.pairDictionary[key] = (value, chaining?(key, value))
        
        self.core.broadcast(value: .inserted(key: key, value: value))
    }
    
    private func replace(key: Key, value: Value, chaining: ((Key, Value) -> AnyObserver)?) {
        guard self.pairDictionary[key] != nil else {
            fatalError()
        }
        
        self.pairDictionary[key] = (value, chaining?(key, value))
        
        self.core.broadcast(value: .replaced(key: key, value: value))
    }
    
    private func replace(_ dictionary: [Key: Value], chaining: ((Key, Value) -> AnyObserver)?) {
        var pairs: [Key: ValuePair] = [:]
        for (key, value) in dictionary {
            pairs[key] = (value, chaining?(key, value))
        }
        self.pairDictionary = pairs
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
            if let value = self.pairDictionary[key] {
                return value.value
            } else {
                return nil
            }
        }
        set(value) {
            if let value = value {
                if self.pairDictionary[key] == nil {
                    self.insert(key: key, value: value)
                } else {
                    self.replace(key: key, value: value)
                }
            } else {
                self.removeValue(forKey: key)
            }
        }
    }

    private func chaining() -> ((Key, Value) -> AnyObserver) {
        return { (key: Key, value: Value) in
            value.chain().do({ [weak self] relayedValue in
                if let sself = self {
                    sself.core.broadcast(value: .relayed(relayedValue, key: key, value: value))
                }
            }).end()
        }
    }
}
