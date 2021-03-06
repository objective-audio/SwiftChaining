//
//  UIBarButtonItemAdapter.swift
//

import Foundation

#if os(iOS)

import UIKit

final public class UIBarButtonItemAdapter: NSObject {
    private weak var item: UIBarButtonItem?
    
    public init(_ item: UIBarButtonItem) {
        self.item = item
        
        super.init()
        
        item.target = self
        item.action = #selector(UIBarButtonItemAdapter.notify(_:))
    }
    
    deinit {
        self.invalidate()
    }
    
    public func invalidate() {
        self.item?.target = nil
        self.item?.action = nil
        self.item = nil
    }
    
    @objc private func notify(_ chainer: UIBarButtonItem) {
        self.broadcast(value: chainer)
    }
}

extension UIBarButtonItemAdapter: Sendable {
    public typealias ChainValue = UIBarButtonItem
}

#endif
