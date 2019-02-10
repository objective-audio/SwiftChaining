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

    func testNotificationAdapter() {
        let postObj = TestPostObject()
        
        let adapter = NotificationAdapter(.testNotification, object: postObj)
        
        var received: TestPostObject?
        
        let observer = adapter.chain().do { value in received = value.object as? TestPostObject }.end()
        
        postObj.post()
        
        XCTAssertNotNil(received)
        XCTAssertEqual(ObjectIdentifier(received!), ObjectIdentifier(postObj))
        
        observer.invalidate()
    }
    
    func testInvalidate() {
        let postObj = TestPostObject()
        
        let adapter = NotificationAdapter(.testNotification, object: postObj)
        
        var received: TestPostObject?
        
        let observer = adapter.chain().do { value in received = value.object as? TestPostObject }.end()
        
        adapter.invalidate()
        
        postObj.post()
        
        XCTAssertNil(received)
        
        observer.invalidate()
    }
    
    func testDeinit() {
        let postObj = TestPostObject()
        
        var received: TestPostObject?
        
        do {
            let adapter = NotificationAdapter(.testNotification, object: postObj)
            
            let observer = adapter.chain().do { value in received = value.object as? TestPostObject }.end()
            
            postObj.post()
            
            XCTAssertNotNil(received)
            
            received = nil
            
            observer.invalidate()
        }
        
        postObj.post()
        
        XCTAssertNil(received)
    }
    
    func testNotificationCenter() {
        let center = NotificationCenter()
        
        let postObj = TestPostObject(center)
        
        let adapter = NotificationAdapter(.testNotification, object: postObj, notificationCenter: center)
        
        var received: [TestPostObject?] = []
        
        let observer = adapter.chain().do { received.append($0.object as? TestPostObject) }.end()
        
        postObj.post()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(ObjectIdentifier(received[0]!), ObjectIdentifier(postObj))
        
        observer.invalidate()
    }
}
