//
//  UIControlAdapter.swift
//

#if os(iOS)

import UIKit

final public class UIControlAdapter<T: UIControl>: NSObject {
    private weak var control: UIControl?
    private let events: UIControl.Event
    
    public init(_ control: T, events: UIControl.Event) {
        self.control = control
        self.events = events
        
        super.init()
        
        control.addTarget(self,
                          action: #selector(UIControlAdapter.notify(_:)),
                          for: events)
    }
    
    deinit {
        self.invalidate()
    }
    
    public func invalidate() {
        self.control?.removeTarget(self,
                                   action: #selector(UIControlAdapter.notify(_:)),
                                   for: self.events)
        self.control = nil
    }
    
    @objc private func notify(_ chainer: UIControl) {
        if let chainer = chainer as? T {
            self.broadcast(value: chainer)
        }
    }
}

extension UIControlAdapter: Chainable {
    public typealias ChainType = Sendable<T>
}

#endif
