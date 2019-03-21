//
//  End.swift
//

import Foundation

extension Chain {
    public func end() -> Observer<Chainer> {
        guard let joint = self.pullJoint() else {
            fatalError()
        }
        
        let handler: JointHandler<Out> = { _, _ in }
        joint.appendHandler(handler)
        
        return Observer<Chainer>(joint: joint)
    }
}

extension Chain where Chainer: Fetchable {
    public func sync() -> Observer<Chainer> {
        let observer = self.end()
        observer.fetch()
        return observer
    }
}

