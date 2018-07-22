//
//  NotificationAlias.swift
//

import Foundation

final public class NotificationAlias {
    public let core = SenderCore<NotificationAlias>()
    private var observer: Any!
    
    public convenience init(_ name: Notification.Name) {
        self.init(name, object: nil)
    }
    
    public init(_ name: Notification.Name, object: Any?) {
        self.observer = NotificationCenter.default.addObserver(forName: name, object: object, queue: OperationQueue.main) { [unowned self] notification in
            self.core.broadcast(value: notification)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self.observer)
    }
}

extension NotificationAlias: Sendable {
    public typealias SendValue = Notification
}
