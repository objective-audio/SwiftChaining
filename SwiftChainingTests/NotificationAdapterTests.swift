//
//  NotificationAdapterTests.swift
//

import XCTest
import Chaining

extension Notification.Name {
    fileprivate static let testNotification = NSNotification.Name("TestNotification")
}

fileprivate class TestPostObject {
    let notificationCenter: NotificationCenter
    
    init(_ center: NotificationCenter = .default) {
        self.notificationCenter = center
    }
    
    func post() {
        self.notificationCenter.post(name: .testNotification, object: self)
    }
}

class NotificationAdapterTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNameAndObject() {
        let postObj1 = TestPostObject()
        let postObj2 = TestPostObject()
        
        let adapter = NotificationAdapter(.testNotification, object: postObj1)
        
        var received: [TestPostObject?] = []
        
        let observer = adapter.chain().do { received.append($0.object as? TestPostObject) }.end()
        
        postObj1.post()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(ObjectIdentifier(received[0]!), ObjectIdentifier(postObj1))
        
        postObj2.post()
        
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
    
    func testInvalidate() {
        let postObj = TestPostObject()
        
        let adapter = NotificationAdapter(.testNotification, object: postObj)
        
        var received: [TestPostObject?] = []
        
        let observer = adapter.chain().do { received.append($0.object as? TestPostObject) }.end()
        
        adapter.invalidate()
        
        postObj.post()
        
        XCTAssertEqual(received.count, 0)
        
        observer.invalidate()
    }
    
    func testDeinit() {
        let postObj = TestPostObject()
        
        var received: [TestPostObject?] = []
        
        do {
            let adapter = NotificationAdapter(.testNotification, object: postObj)
            
            let observer = adapter.chain().do { received.append($0.object as? TestPostObject) }.end()
            
            postObj.post()
            
            XCTAssertEqual(received.count, 1)
            
            observer.invalidate()
        }
        
        postObj.post()
        
        XCTAssertEqual(received.count, 1)
    }
    
    func testNotificationCenter() {
        let center1 = NotificationCenter()
        let center2 = NotificationCenter()
        
        let postObj1 = TestPostObject(center1)
        let postObj2 = TestPostObject(center2)
        
        let adapter = NotificationAdapter(.testNotification, object: postObj1, notificationCenter: center1)
        
        var received: [TestPostObject?] = []
        
        let observer = adapter.chain().do { received.append($0.object as? TestPostObject) }.end()
        
        postObj1.post()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(ObjectIdentifier(received[0]!), ObjectIdentifier(postObj1))
        
        postObj2.post()
        
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
    
    func testNameOnly() {
        let postObj1 = TestPostObject()
        let postObj2 = TestPostObject()
        
        let adapter = NotificationAdapter(.testNotification)
        
        var received: [TestPostObject?] = []
        
        let observer = adapter.chain().do { received.append($0.object as? TestPostObject) }.end()
        
        postObj1.post()
        
        XCTAssertEqual(received.count, 1)
        
        postObj2.post()
        
        XCTAssertEqual(received.count, 2)
        
        observer.invalidate()
    }
}
