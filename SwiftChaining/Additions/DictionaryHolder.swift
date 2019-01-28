//
//  DictionaryHolder.swift
//

import Foundation

public protocol DictionaryProtocol {
    associatedtype Key: Hashable
    associatedtype Value
    
    var rawDictionary: [Key: Value] { get }
}

extension DictionaryProtocol {
    public var count: Int { return self.rawDictionary.count }
    public var capacity: Int { return self.rawDictionary.capacity }
}

final public class DictionaryHolder<K: Hashable, V> {
    public typealias Key = K
    public typealias Value = V
    
    public private(set) var rawDictionary: [Key: Value] = [:]
    
    public enum Event {
        case fetched([Key: Value])
        case any([Key: Value])
        case inserted(key: Key, value: Value)
        case removed(key: Key, value: Value)
        case replaced(key: Key, value: Value)
    }
    
    public init() {}
    
    public convenience init(_ dictionary: [Key: Value]) {
        self.init()
        
        self.set(dictionary)
    }
    
    public func set(_ dictionary: [Key: Value]) {
        self.rawDictionary = dictionary
        self.broadcast(value: .any(dictionary))
    }
    
    public func replace(key: Key, value: Value) {
        guard self.rawDictionary[key] != nil else {
            fatalError()
        }
        
        self.rawDictionary[key] = value
        
        self.broadcast(value: .replaced(key: key, value: value))
    }
    
    public func insert(key: Key, value: Value) {
        guard self.rawDictionary[key] == nil else {
            fatalError()
        }
        
        self.rawDictionary[key] = value
        
        self.broadcast(value: .inserted(key: key, value: value))
    }
    
    @discardableResult
    public func removeValue(forKey key: Key) -> Value? {
        if let value = self.rawDictionary.removeValue(forKey: key) {
            self.broadcast(value: .removed(key: key, value: value))
            
            return value
        } else {
            return nil
        }
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        self.rawDictionary.removeAll(keepingCapacity: keepCapacity)
        self.broadcast(value: .any([:]))
    }
    
    public func reserveCapacity(_ capacity: Int) {
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

extension DictionaryHolder: DictionaryProtocol {}

extension DictionaryHolder: Fetchable {
    public typealias SendValue = Event
    
    public func fetchedValue() -> Event? {
        return .fetched(self.rawDictionary)
    }
}
