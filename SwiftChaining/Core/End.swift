//
//  End.swift
//

import Foundation

extension Chain {
    public func end() -> Observer<Sender> {
        guard let joint = self.joint else {
            fatalError()
        }
        
        self.joint = nil
        
        let handler = self.handler
        
        joint.handlers.append({ value in _ = handler(value) })
        return Observer<Sender>(joint: joint)
    }
}

extension Chain where Sender: Fetchable {
    public func sync() -> Observer<Sender> {
        let observer = self.end()
        observer.broadcast()
        return observer
    }
}
