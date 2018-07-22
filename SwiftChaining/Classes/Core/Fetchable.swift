//
//  Fetchable.swift
//

import Foundation

public protocol Fetchable: Sendable {
    func fetchedValue() -> SendValue
}

extension Fetchable {
    public func fetch(for joint: AnyJoint) {
        self.core.send(value: self.fetchedValue(), to: joint)
    }
}

extension Fetchable where SendValue: Sendable {
    public typealias RelayingFetcher = Fetcher<RelayingEvent>
    public typealias RelayingFetcherChain = Chain<RelayingEvent, RelayingEvent, RelayingFetcher>
    
    public func relayedChain() -> RelayingFetcherChain {
        if self.core.relaySender == nil {
            let fetcher = RelayingFetcher() { [weak self] in return .current(self!.fetchedValue()) }
            self.core.relaySender = fetcher
            self.core.relayObserver = self.chain().do({ [weak self] value in
                fetcher.broadcast(value: .current(value))
                
                self?.core.relayValueObserver = value.chain().do({ value in
                    fetcher.core.broadcast(value: .relayed(value))
                }).end()
            }).sync()
        }
        
        let fetcher = self.core.relaySender as! RelayingFetcher
        
        return fetcher.chain()
    }
}

extension Fetchable where SendValue: Fetchable {
    public func relayedChain() -> RelayingFetcherChain {
        if self.core.relaySender == nil {
            let fetcher = RelayingFetcher() { [weak self] in return .current(self!.fetchedValue()) }
            self.core.relaySender = fetcher
            self.core.relayObserver = self.chain().do({ [weak self] value in
                fetcher.broadcast(value: .current(value))
                
                self?.core.relayValueObserver = value.chain().do({ value in
                    fetcher.core.broadcast(value: .relayed(value))
                }).sync()
            }).sync()
        }
        
        let fetcher = self.core.relaySender as! RelayingFetcher
        
        return fetcher.chain()
    }
}
