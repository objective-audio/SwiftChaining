//
//  End.swift
//

import Foundation

extension Chain {
    public func end() -> Observer<Sender> {
        guard let joint = self.pullJoint() else {
            fatalError()
        }
        
        let handler: JointHandler<Out> = { _, _ in }
        joint.handlers.append(handler)
        
        return Observer<Sender>(joint: joint)
    }
}

extension Chain where Sender: Fetchable {
    public func sync() -> Observer<Sender> {
        let observer = self.end()
        observer.fetch()
        return observer
    }
}

