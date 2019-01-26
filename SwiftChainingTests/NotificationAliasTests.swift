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
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNotificationAlias() {
        let postObj = TestPostObject()
        
        let alias = NotificationAdapter(.testNotification, object: postObj)
        
        var received: TestPostObject?
        
        let observer = alias.chain().do { value in received = value.object as? TestPostObject }.end()
        
        postObj.post()
        
        XCTAssertNotNil(received)
        XCTAssertEqual(ObjectIdentifier(received!), ObjectIdentifier(postObj))
        
        observer.invalidate()
    }
    
    func testInvalidate() {
        let postObj = TestPostObject()
        
        let alias = NotificationAdapter(.testNotification, object: postObj)
        
        var received: TestPostObject?
        
        let observer = alias.chain().do { value in received = value.object as? TestPostObject }.end()
        
        alias.invalidate()
        
        postObj.post()
        
        XCTAssertNil(received)
        
        observer.invalidate()
    }
    
    func testDeinit() {
        let postObj = TestPostObject()
        
        var received: TestPostObject?
        
        do {
            let alias = NotificationAdapter(.testNotification, object: postObj)
            
            let observer = alias.chain().do { value in received = value.object as? TestPostObject }.end()
            
            postObj.post()
            
            XCTAssertNotNil(received)
            
            received = nil
            
            observer.invalidate()
        }
        
        postObj.post()
        
        XCTAssertNil(received)
    }
}
