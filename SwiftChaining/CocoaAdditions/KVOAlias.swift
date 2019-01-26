//
//  PropertyAlias.swift
//

import Foundation

final public class KVOAlias<Root: NSObject, T> {
    private let holder: Holder<T>
    private var observer: AnyObserver?
    private var observation: NSKeyValueObservation?
    private let lock = NSLock()
    
    public var value: T {
        set { self.holder.value = newValue }
        get { return self.holder.value }
    }
    
    public init(object: Root, keyPath: ReferenceWritableKeyPath<Root, T>) {
        self.holder = Holder(object[keyPath: keyPath])
        
        self.observer = self.holder.chain().do({ [weak object, unowned self] value in
            if self.lock.try() {
                if let object = object {
                    object[keyPath: keyPath] = value
                }
                self.lock.unlock()
            }
        }).sync()
        
        self.observation = object.observe(keyPath, options: [.new]) { [unowned self] (root, change) in
            if self.lock.try() {
                if let value = change.newValue {
                    self.holder.value = value
                }
                self.lock.unlock()
            }
        }
    }
    
    deinit {
        self.invalidate()
    }
    
    public func chain() -> Holder<T>.SenderChain {
        return self.holder.chain()
    }
    
    public func invalidate() {
        self.observation?.invalidate()
        self.observer?.invalidate()
        
        self.observation = nil
    }
}

extension KVOAlias: Receivable {
    public func receive(value: T) {
        self.value = value
    }
}
