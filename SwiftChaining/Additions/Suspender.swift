//
//  Suspender.swift
//

import Foundation

public protocol AnySuspender: AnyObserver {
    func resume()
    func suspend()
}

public class Suspender {
    public typealias ChainingHandler = () -> AnyObserver?
    
    public enum State {
        case suspended
        case resumed
        case invalidated
    }
    
    public private(set) var state = Holder<State>(.suspended)
    
    private var observer: AnyObserver?
    private var chaining: ChainingHandler!
    
    public init(_ chaining: @escaping ChainingHandler) {
        self.chaining = chaining
    }
    
    deinit {
        self.invalidate()
    }
}

extension Suspender: AnySuspender {
    public func resume() {
        if case .suspended = self.state.value {
            self.observer = self.chaining()
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
        case .resumed:
            self.chaining = nil
            self.observer?.invalidate()
            self.observer = nil
            self.state.value = .invalidated
        case .suspended:
            self.chaining = nil
            self.state.value = .invalidated
        case .invalidated:
            break
        }
    }
}
