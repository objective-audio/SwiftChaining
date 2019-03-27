//
//  Alias.swift
//

import Foundation

public class Alias<Chainer: Chainable> {
    private let chainer: Chainer
    
    public init(_ chainer: Chainer) {
        self.chainer = chainer
    }
}

extension Alias where Chainer: Sendable {
    public func chain() -> Chainer.FirstChain {
        return self.chainer.chain()
    }
}

extension Alias where Chainer: Fetchable {
    public func value() -> Chainer.ChainValue {
        return self.chainer.fetchedValue()
    }
    
    public func safeValue() -> Chainer.ChainValue? {
        if self.chainer.canFetch() {
            return self.chainer.fetchedValue()
        } else {
            return nil
        }
    }
}
