//
//  RetainSenderTests.swift
//

import XCTest
import Chaining

class RetainSenderTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testRetainSender() {
        let pool = ObserverPool()
        let name = Notification.Name("RetainSenderTest")
        
        var received: [Notification] = []
        
        NotificationAdapter(name).retain().chain()
            .do { received.append($0) }
            .end().addTo(pool)
        
        NotificationCenter.default.post(name: name, object: nil)
        
        XCTAssertEqual(received.count, 1)
        
        pool.invalidate()
        
        NotificationCenter.default.post(name: name, object: nil)
        
        XCTAssertEqual(received.count, 1)
    }
    
    func testNoRetainSender() {
        let pool = ObserverPool()
        let name = Notification.Name("NoRetainSenderTest")
        
        var received: [Notification] = []
        
        do {
            let adapter = NotificationAdapter(name)
            
            adapter.chain()
                .do { received.append($0) }
                .end().addTo(pool)
        }
        
        NotificationCenter.default.post(name: name, object: nil)
        
        XCTAssertEqual(received.count, 0)
        
        pool.invalidate()
    }
}
