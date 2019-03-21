//
//  PropertyAdapter.swift
//

import Foundation

public protocol AnyPropertyAdapter: class {}

public final class PropertyAdapter<Root: AnyObject, T>: AnyPropertyAdapter {
    
    public var value: T {
        get { return self.target![keyPath: self.keyPath] }
        set {
            if let target = self.target {
                target[keyPath: self.keyPath] = newValue
                self.broadcast(value: newValue)
            }
        }
    }
    
    public var safeValue: T? {
        get {
            guard let target = self.target else { return nil }
            return target[keyPath: self.keyPath]
        }
    }
    
    private weak var target: Root?
    private let targetId: ObjectIdentifier?
    private let keyPath: ReferenceWritableKeyPath<Root, T>
    
    public init(_ target: Root, keyPath: ReferenceWritableKeyPath<Root, T>) {
        self.target = target
        self.targetId = nil
        self.keyPath = keyPath
    }
    
    fileprivate init(common target: Root, keyPath: ReferenceWritableKeyPath<Root, T>) {
        self.target = target
        self.targetId = ObjectIdentifier(target)
        self.keyPath = keyPath
    }
    
    deinit {
        guard let targetId = self.targetId else {
            return
        }
        
        if self.target != nil {
            PropertyAdapterCommon.shared.remove(targetId: targetId, keyPath: self.keyPath)
        } else {
            PropertyAdapterCommon.shared.remove(targetId: targetId, adapterId: ObjectIdentifier(self))
        }
    }
    
    public static func common(_ target: Root, keyPath: ReferenceWritableKeyPath<Root, T>) -> PropertyAdapter<Root, T> {
        return PropertyAdapterCommon.shared.getOrCreateAdapter(target, keyPath: keyPath)
    }
}

extension PropertyAdapter: Syncable {
    public typealias ChainValue = T
    
    public func canFetch() -> Bool {
        return self.target != nil
    }
    
    public func fetchedValue() -> PropertyAdapter<Root, T>.ChainValue {
        return self.value
    }
}

extension PropertyAdapter: Receivable {
    public typealias ReceiveValue = T
    
    public func receive(value: T) {
        self.value = value
    }
}

// MARK: - Common

internal class PropertyAdapterCommon {
    internal static let shared = PropertyAdapterCommon()
    
    private class AdapterWrapper {
        weak var adapter: AnyPropertyAdapter?
        let adapterId: ObjectIdentifier
        
        init(adapter: AnyPropertyAdapter) {
            self.adapter = adapter
            self.adapterId = ObjectIdentifier(adapter)
        }
    }
    
    private class TargetWrapper {
        private(set) weak var target: AnyObject?
        fileprivate var adapters: [AnyHashable: AdapterWrapper] = [:]
        
        init(_ target: AnyObject) {
            self.target = target
        }
    }
    
    private var targetWrappers: [ObjectIdentifier: TargetWrapper] = [:]
    
    fileprivate func getOrCreateAdapter<Root: AnyObject, T>(_ target: Root,
                                                            keyPath: ReferenceWritableKeyPath<Root, T>) -> PropertyAdapter<Root, T> {
        let targetId = ObjectIdentifier(target)
        
        if let targetWrapper = self.targetWrappers[targetId], targetWrapper.target == nil {
            self.targetWrappers.removeValue(forKey: targetId)
        }
        
        if self.targetWrappers[targetId] == nil {
            self.targetWrappers[targetId] = TargetWrapper(target)
        }
        
        let targetWrapper = self.targetWrappers[targetId]!
        
        if let adapterWrapper = targetWrapper.adapters[keyPath] {
            return adapterWrapper.adapter as! PropertyAdapter<Root, T>
        } else {
            let adapter = PropertyAdapter(common: target, keyPath: keyPath)
            targetWrapper.adapters[keyPath] = AdapterWrapper(adapter: adapter)
            return adapter
        }
    }
    
    fileprivate func remove(targetId: ObjectIdentifier, keyPath: AnyHashable) {
        guard let targetWrapper = self.targetWrappers[targetId] else {
            return
        }
        
        targetWrapper.adapters.removeValue(forKey: keyPath)
        
        if targetWrapper.adapters.count == 0 {
            self.targetWrappers.removeValue(forKey: targetId)
        }
    }
    
    fileprivate func remove(targetId: ObjectIdentifier, adapterId: ObjectIdentifier) {
        guard let targetWrapper = self.targetWrappers[targetId] else {
            return
        }
        
        if let index = targetWrapper.adapters.firstIndex(where: { $1.adapterId == adapterId }) {
            targetWrapper.adapters.remove(at: index)
        }
        
        if targetWrapper.adapters.count == 0 {
            self.targetWrappers.removeValue(forKey: targetId)
        }
    }
}
