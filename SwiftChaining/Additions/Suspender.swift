//
//  Suspender.swift
//

import Foundation

public protocol AnySuspender: AnyObserver {
    func resume()
    func suspend()
}

public class Suspender<T: AnyObject> {
    public typealias ChainingHandler = (T) -> AnyObserver?
    
    public enum State {
        case suspended
        case resumed
        case invalidated
    }
    
    public private(set) var state = Holder<State>(.suspended)
    
    private weak var object: T?
    private var observer: AnyObserver?
    private var chaining: ChainingHandler!
    
    public init(_ context: T, chaining: @escaping ChainingHandler) {
        self.object = context
        self.chaining = chaining
    }
    
    deinit {
        self.invalidate()
    }
}

extension Suspender: AnySuspender {
    public func resume() {
        if case .suspended = self.state.value, let context = self.object {
            self.observer = self.chaining(context)
            self.state.value = .resumed
        }
    }
    
    public func suspend() {
        if case .resumed = self.state.value {
            self.observer = nil
            self.state.value = .suspended
        }
    }
    
    public func invalidate() {
        switch self.state.value {
        case .suspended:
            self.chaining = nil
            self.observer?.invalidate()
            self.observer = nil
            self.state.value = .invalidated
        case .resumed:
            self.chaining = nil
            self.state.value = .invalidated
        case .invalidated:
            break
        }
    }
}
