//
//  SuspenderTests.swift
//

import XCTest
import Chaining

class SuspenderTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testSendable() {
        let notifier = Notifier<Int>()
        let suspender = Suspender()
        
        var received: [Int] = []
        
        let observer = notifier.chain().suspend(suspender).do { received.append($0) }.end()
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        suspender.isSuspend = true
        
        notifier.notify(value: 2)
        
        XCTAssertEqual(received.count, 1)
        
        suspender.isSuspend = false
        
        notifier.notify(value: 3)
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], 3)
        
        observer.invalidate()
    }
    
    func testFetchable() {
        let holder = ValueHolder(0)
        let suspender = Suspender()
        
        var received: [Int] = []
        
        let observer = holder.chain().suspend(suspender).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 0)
        
        holder.value = 1
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], 1)
        
        suspender.isSuspend = true
        
        holder.value = 2
        
        XCTAssertEqual(received.count, 2)
        
        suspender.isSuspend = false
        
        XCTAssertEqual(received.count, 3)
        XCTAssertEqual(received[2], 2)
        
        observer.invalidate()
    }
    
    func testSendableDefaultTrue() {
        let notifier = Notifier<Int>()
        let suspender = Suspender(true)
        
        var received: [Int] = []
        
        let observer = notifier.chain().suspend(suspender).do { received.append($0) }.end()
        
        notifier.notify(value: 1)
        
        suspender.isSuspend = false
        
        XCTAssertEqual(received.count, 0)
        
        observer.invalidate()
    }
    
    func testFetchableDefaultTrue() {
        let holder = ValueHolder(0)
        let suspender = Suspender(true)
        
        var received: [Int] = []
        
        let observer = holder.chain().suspend(suspender).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 0)
        
        suspender.isSuspend = false
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 0)
        
        observer.invalidate()
    }
}
