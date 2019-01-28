//
//  NotificationAdapter.swift
//

import Foundation

final public class NotificationAdapter {
    private var observer: NSObjectProtocol?
    
    public convenience init(_ name: Notification.Name) {
        self.init(name, object: nil)
    }
    
    public init(_ name: Notification.Name, object: Any?) {
        self.observer = NotificationCenter.default.addObserver(forName: name, object: object, queue: OperationQueue.main) { [unowned self] notification in
            self.broadcast(value: notification)
        }
    }
    
    deinit {
        self.invalidate()
    }
    
    public func invalidate() {
        if let observer = self.observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

extension NotificationAdapter: Sendable {
    public typealias SendValue = Notification
}
