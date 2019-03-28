//
//  ReadOnly.swift
//

import Foundation

public class ReadOnly<Chainer: Chainable> {
    private weak var chainer: Chainer?
    
    public init(_ chainer: Chainer) {
        self.chainer = chainer
    }
}

extension ReadOnly where Chainer: Sendable {
    public func chain() -> Chainer.FirstChain? {
        return self.chainer?.chain()
    }
}

extension ReadOnly where Chainer: Fetchable {
    public var value: Chainer.ChainValue {
        return self.chainer!.fetchedValue()
    }
    
    public var safeValue: Chainer.ChainValue? {
        if let chainer = self.chainer, chainer.canFetch() {
            return chainer.fetchedValue()
        } else {
            return nil
        }
    }
}
