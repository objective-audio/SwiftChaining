//
//  ForEach.swift
//

import Foundation

extension Chain where Out: Sequence {
    public typealias ForEachOut = (Int, Out.Element)
    public typealias ForEachChain = Chain<ForEachOut, ForEachOut, Sender>
    
    public func forEach() -> ForEachChain {
        guard let joint = self.joint else {
            fatalError()
        }
        
        self.joint = nil
        
        let handler = self.handler
        let nextIndex = joint.handlers.count + 1
        
        let newHandler: (HandlerIn) -> Void = { [weak joint] value in
            if let joint = joint, let nextHandler = joint.handlers[nextIndex] as? (ForEachOut) -> Void {
                for (index, element) in handler(value).enumerated() {
                    nextHandler((index, element))
                }
            }
        }
        
        joint.handlers.append(newHandler)
        
        return ForEachChain(joint: joint) { $0 }
    }
}
