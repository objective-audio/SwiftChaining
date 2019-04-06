//
//  KVOAdapter.swift
//

import Foundation

final public class KVOAdapter<Root: NSObject, T> {
    public enum Default {
        case value(T)
        case none
        
        public var hasValue: Bool {
            switch self {
            case .value:
                return true
            case .none:
                return false
            }
        }
    }
    
    private enum Kind {
        case typed(ReferenceWritableKeyPath<Root, T>, NSKeyValueObservation)
        case untyped(String, KVOAdapterUntypedObserver)
        case invalid
    }
    
    private weak var target: Root?
    private var kind: Kind = .invalid
    private let `default`: Default
    
    public var value: T {
        get {
            if let safeValue = self.safeValue {
                return safeValue
            } else {
                fatalError()
            }
        }
            
        set {
            switch self.kind {
            case .typed(let keyPath, _):
                self.target?[keyPath: keyPath] = newValue
            case .untyped(let keyPath, _):
                self.target?.setValue(newValue, forKeyPath: keyPath)
            case .invalid:
                break
            }
        }
    }
    
    public var safeValue: T? {
        guard let target = self.target else { return nil }

        switch self.kind {
        case .typed(let keyPath, _):
            return target[keyPath: keyPath]
        case .untyped(let keyPath, _):
            return target.value(forKeyPath: keyPath) as? T
        case .invalid:
            return nil
        }
    }
    
    public init(_ target: Root, keyPath: ReferenceWritableKeyPath<Root, T>, `default` def: Default = .none) {
        self.target = target
        self.default = def
        
        let observation =
            target.observe(keyPath,
                           options: [.new]) { [unowned self] (root, change) in
                            if let value = self.safeValue {
                                self.broadcast(value: value)
                            } else if case .value(let value) = self.default {
                                self.broadcast(value: value)
                            }
        }
        
        self.kind = .typed(keyPath, observation)
    }
    
    public init(_ target: Root, keyPath: String, `default` def: Default = .none) {
        self.target = target
        self.default = def
        
        let observer = KVOAdapterUntypedObserver(keyPath: keyPath) { [unowned self] change in
            if let value = self.safeValue {
                self.broadcast(value: value)
            } else if case .value(let value) = self.default {
                self.broadcast(value: value)
            }
        }
        
        self.kind = .untyped(keyPath, observer)
        
        target.addObserver(observer, forKeyPath: keyPath, options: .new, context: nil)
    }
    
    deinit {
        self.invalidate()
    }
    
    public func invalidate() {
        switch self.kind {
        case .typed(_, let observation):
            observation.invalidate()
            self.kind = .invalid
        case .untyped(let keyPath, let observer):
            self.target?.removeObserver(observer, forKeyPath: keyPath)
            self.kind = .invalid
        case .invalid:
            break
        }
        
        self.target = nil
    }
}

extension KVOAdapter: Chainable {
    public typealias ChainType = Syncable<T>
    
    public func canFetch() -> Bool {
        switch self.kind {
        case .typed, .untyped:
            return self.safeValue != nil || self.default.hasValue
        case .invalid:
            return false
        }
    }
    
    public func fetchedValue() -> KVOAdapter<Root, T>.ChainValue {
        if let value = self.safeValue {
            return value
        } else if case .value(let value) = self.default {
            return value
        } else {
            fatalError()
        }
    }
}

extension KVOAdapter: Receivable {
    public typealias ReceiveValue = T
    
    public func receive(value: T) {
        self.value = value
    }
}

@objc fileprivate class KVOAdapterUntypedObserver: NSObject {
    private let keyPath: String
    private let handler: ([NSKeyValueChangeKey : Any]) -> Void
    
    init(keyPath: String, handler: @escaping ([NSKeyValueChangeKey : Any]) -> Void) {
        self.keyPath = keyPath
        self.handler = handler
        
        super.init()
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if self.keyPath == keyPath, let change = change {
            self.handler(change)
        }
    }
}
