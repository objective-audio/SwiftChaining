//
//  NotificationAdapter.swift
//

import Foundation

final public class NotificationAdapter {
    private var observer: NSObjectProtocol?
    
    public init(_ name: Notification.Name, object: Any? = nil, notificationCenter: NotificationCenter = .default) {
        self.observer = notificationCenter.addObserver(forName: name, object: object, queue: OperationQueue.main) { [unowned self] notification in
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
