//
//  NotifierTests.swift
//

import XCTest
import Chaining

class NotifierTests: XCTestCase {
    var pool = ObserverPool()
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        self.pool.invalidate()
        super.tearDown()
    }

    func testChainValue() {
        let notifier = Notifier<Int>()
        
        var received: Int?
        
        self.pool += notifier.chain().do { received = $0 }.end()
        
        XCTAssertNil(received)
        
        notifier.notify(value: 3)
        
        XCTAssertEqual(received, 3)
    }
    
    func testChainVoid() {
        let notifier = Notifier<Void>()
        
        var received = false
        
        self.pool += notifier.chain().do { received = true }.end()
        
        XCTAssertFalse(received)
        
        notifier.notify()
        
        XCTAssertTrue(received)
    }
    
    func testReceive() {
        let notifier = Notifier<Int>()
        let receivingNotifier = Notifier<Int>()
        
        self.pool += notifier.chain().receive(receivingNotifier).end()
        
        var received: Int?
        self.pool += receivingNotifier.chain().do { received = $0 }.end()
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(received, 1)
    }
}
