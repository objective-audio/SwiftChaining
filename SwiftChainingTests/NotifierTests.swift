//
//  NotifierTests.swift
//

import XCTest
import Chaining

class NotifierTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testChainValue() {
        let notifier = Notifier<Int>()
        
        var received: [Int] = []
        
        let observer = notifier.chain().do { received.append($0) }.end()
        
        XCTAssertEqual(received.count, 0)
        
        notifier.notify(value: 3)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 3)
        
        observer.invalidate()
    }
    
    func testChainVoid() {
        let notifier = Notifier<Void>()
        
        var received = false
        
        let observer = notifier.chain().do { received = true }.end()
        
        XCTAssertFalse(received)
        
        notifier.notify()
        
        XCTAssertTrue(received)
        
        observer.invalidate()
    }
    
    func testReceive() {
        let notifier = Notifier<Int>()
        let receivingNotifier = Notifier<Int>()
        
        let observer = notifier.chain().sendTo(receivingNotifier).end()
        
        var received: [Int] = []
        let receivingObserver = receivingNotifier.chain().do { received.append($0) }.end()
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        observer.invalidate()
        receivingObserver.invalidate()
    }
    
    func testRecursive() {
        let notifier = Notifier<Int>()
        
        var received: [Int] = []
        
        let observer = notifier.chain().do { received.append($0) }.sendTo(notifier).end()
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
}
