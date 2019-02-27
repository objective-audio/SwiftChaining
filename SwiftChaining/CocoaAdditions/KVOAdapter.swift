//
//  KVOAdapter.swift
//

import Foundation

final public class KVOAdapter<Root: NSObject, T> {
    private weak var target: Root?
    private let keyPath: ReferenceWritableKeyPath<Root, T>
    private var observation: NSKeyValueObservation?
    
    public var value: T {
        get { return self.target![keyPath: self.keyPath] }
        set { self.target?[keyPath: self.keyPath] = newValue }
    }
    
    public var safeValue: T? {
        guard let target = self.target else { return nil }
        return target[keyPath: self.keyPath]
    }
    
    public init(_ target: Root, keyPath: ReferenceWritableKeyPath<Root, T>) {
        self.target = target
        self.keyPath = keyPath
        
        self.observation = target.observe(keyPath, options: [.new]) { [unowned self] (root, change) in
            if let value = change.newValue {
                self.broadcast(value: value)
            }
        }
    }
    
    deinit {
        self.invalidate()
    }
    
    public func invalidate() {
        self.observation?.invalidate()
        self.observation = nil
    }
}

extension KVOAdapter: Fetchable {
    public typealias SendValue = T
    
    public func canFetch() -> Bool {
        return self.target != nil
    }
    
    public func fetchedValue() -> KVOAdapter<Root, T>.SendValue {
        return self.value
    }
}

extension KVOAdapter: Receivable {
    public func receive(value: T) {
        self.value = value
    }
}
