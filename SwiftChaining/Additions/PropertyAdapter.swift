//
//  PropertyAdapter.swift
//

import Foundation

public final class PropertyAdapter<Root: AnyObject, T> {
    public var value: T {
        get { return self.object![keyPath: self.keyPath] }
        set {
            if let object = self.object {
                if self.lock.try() {
                    object[keyPath: self.keyPath] = newValue
                    self.broadcast(value: newValue)
                    self.lock.unlock()
                }
            }
        }
    }
    
    public var safeValue: T? {
        get {
            guard let object = self.object else { return nil }
            return object[keyPath: self.keyPath]
        }
    }
    
    private weak var object: Root?
    private let keyPath: ReferenceWritableKeyPath<Root, T>
    private let lock = NSLock()
    
    public init(_ object: Root, keyPath: ReferenceWritableKeyPath<Root, T>) {
        self.object = object
        self.keyPath = keyPath
    }
}

extension PropertyAdapter: Fetchable {
    public typealias SendValue = T
    
    public func canFetch() -> Bool {
        return self.object != nil
    }
    
    public func fetchedValue() -> PropertyAdapter<Root, T>.SendValue {
        return self.value
    }
}

extension PropertyAdapter: Receivable {
    public func receive(value: T) {
        self.value = value
    }
}
