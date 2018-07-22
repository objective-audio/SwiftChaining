//
//  UIControlAlias.swift
//

import UIKit

final public class UIControlAlias: NSObject {
    public let core = SenderCore<UIControlAlias>()
    
    private weak var control: UIControl?
    private let events: UIControlEvents
    
    public init(_ control: UIControl, events: UIControlEvents) {
        self.control = control
        self.events = events
        
        super.init()
        
        control.addTarget(self, action: #selector(UIControlAlias.notify(_:)), for: events)
    }
    
    deinit {
        self.control?.removeTarget(self, action: #selector(UIControlAlias.notify(_:)), for: self.events)
    }
    
    @objc private func notify(_ sender: UIControl) {
        self.core.broadcast(value: sender)
    }
}

extension UIControlAlias: Sendable {
    public typealias SendValue = UIControl
}
