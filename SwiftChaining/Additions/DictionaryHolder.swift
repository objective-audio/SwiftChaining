//
//  DictionaryHolder.swift
//

import Foundation

public protocol DictionaryReadable {
    associatedtype Key: Hashable
    associatedtype Value
    
    var raw: [Key: Value] { get }
}

extension DictionaryReadable {
    public var count: Int { return self.raw.count }
    public var capacity: Int { return self.raw.capacity }
}

final public class DictionaryHolder<K: Hashable, V> {
    public typealias Key = K
    public typealias Value = V
    
    public private(set) var raw: [Key: Value] = [:]
    
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
        self.raw = dictionary
        self.broadcast(value: .any(dictionary))
    }
    
    public func replace(key: Key, value: Value) {
        guard self.raw[key] != nil else {
            fatalError()
        }
        
        self.raw[key] = value
        
        self.broadcast(value: .replaced(key: key, value: value))
    }
    
    public func insert(key: Key, value: Value) {
        guard self.raw[key] == nil else {
            fatalError()
        }
        
        self.raw[key] = value
        
        self.broadcast(value: .inserted(key: key, value: value))
    }
    
    @discardableResult
    public func removeValue(forKey key: Key) -> Value? {
        if let value = self.raw.removeValue(forKey: key) {
            self.broadcast(value: .removed(key: key, value: value))
            
            return value
        } else {
            return nil
        }
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        self.raw.removeAll(keepingCapacity: keepCapacity)
        self.broadcast(value: .any([:]))
    }
    
    public func reserveCapacity(_ capacity: Int) {
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
}

extension DictionaryHolder: DictionaryReadable {}

extension DictionaryHolder: Fetchable {
    public typealias SendValue = Event
    
    public func fetchedValue() -> Event {
        return .fetched(self.raw)
    }
}
