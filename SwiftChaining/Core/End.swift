//
//  End.swift
//

import Foundation

extension Chain {
    public func end() -> Observer<ChainType> {
        guard let joint = self.pullJoint() else {
            fatalError()
        }
        
        let handler: JointHandler<Out> = { _, _ in }
        joint.appendHandler(handler)
        
        return Observer<ChainType>(joint: joint)
    }
}

extension Chain where ChainType: FetchableProtocol {
    public func sync() -> Observer<ChainType> {
        let observer = self.end()
        observer.fetch()
        return observer
    }
}
