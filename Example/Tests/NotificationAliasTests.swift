//
//  NotificationAliasTests.swift
//

import XCTest
import Chaining

extension Notification.Name {
    fileprivate static let testNotification = NSNotification.Name("TestNotification")
}

fileprivate class TestPostObject {
    func post() {
        NotificationCenter.default.post(name: .testNotification, object: self)
    }
}

class NotificationAliasTests: XCTestCase {
    var pool = ObserverPool()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        self.pool.invalidate()
        super.tearDown()
    }

    func testNotificationAlias() {
        let postObj = TestPostObject()
        
        let alias = NotificationAlias(.testNotification, object: postObj)
        
        var received: TestPostObject?
        
        self.pool += alias.chain().do { value in received = value.object as? TestPostObject }.end()
        
        postObj.post()
        
        XCTAssertNotNil(received)
        XCTAssertEqual(ObjectIdentifier(received!), ObjectIdentifier(postObj))
    }
}
