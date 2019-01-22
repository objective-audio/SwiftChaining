//
//  Fetchable.swift
//

import Foundation

public protocol Fetchable: Sendable {
    func fetchedValue() -> SendValue?
}

extension Fetchable {
    public func fetch(for joint: AnyJoint) {
        if let fetched = self.fetchedValue() {
            self.getCore()?.send(value: fetched, to: joint)
        }
    }
}

extension Fetchable where SendValue: Sendable {
    public typealias RelayingFetcher = Fetcher<RelayingEvent>
    public typealias RelayingFetcherChain = Chain<RelayingEvent, RelayingEvent, RelayingFetcher>
    
    public func relayedChain() -> RelayingFetcherChain {
        let core = self.getOrCreateCore()
        
        if core.relaySender == nil {
            let fetcher = RelayingFetcher() { [weak self] in
                if let fetched = self?.fetchedValue() {
                    return .current(fetched)
                } else {
                    return nil
                }
            }
            core.relaySender = fetcher
            core.relayObserver = self.chain().do({ [weak self] value in
                fetcher.broadcast(value: .current(value))
                
                self?.getCore()?.relayValueObserver = value.chain().do({ value in
                    fetcher.broadcast(value: .relayed(value))
                }).end()
            }).sync()
        }
        
        let fetcher = core.relaySender as! RelayingFetcher
        
        return fetcher.chain()
    }
}

extension Fetchable where SendValue: Fetchable {
    public func relayedChain() -> RelayingFetcherChain {
        let core = self.getOrCreateCore()
        
        if core.relaySender == nil {
            let fetcher = RelayingFetcher() { [weak self] in
                if let fetched = self?.fetchedValue() {
                    return .current(fetched)
                } else {
                    return nil
                }
            }
            core.relaySender = fetcher
            core.relayObserver = self.chain().do({ [weak self] value in
                fetcher.broadcast(value: .current(value))
                
                self?.getCore()?.relayValueObserver = value.chain().do({ value in
                    fetcher.broadcast(value: .relayed(value))
                }).sync()
            }).sync()
        }
        
        let fetcher = core.relaySender as! RelayingFetcher
        
        return fetcher.chain()
    }
}
