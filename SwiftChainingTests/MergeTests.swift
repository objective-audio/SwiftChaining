//
//  MergeTests.swift
//

import XCTest
import Chaining

class MergeTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testMergeEachFetchable() {
        let main = ValueHolder<Int>(0)
        let sub = ValueHolder<Int>(1)
        
        var received: [Int] = []
        
        let observer = main.chain().merge(sub.chain()).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[0], 0)
        XCTAssertEqual(received[1], 1)
        
        main.value = 3
        
        XCTAssertEqual(received.count, 3)
        XCTAssertEqual(received[2], 3)
        
        sub.value = 4
        
        XCTAssertEqual(received.count, 4)
        XCTAssertEqual(received[3], 4)
        
        observer.invalidate()
    }

    func testMergeMainFetchable() {
        let main = ValueHolder<Int>(0)
        let sub = Notifier<Int>()
        
        var received: [Int] = []
        
        let observer = main.chain().merge(sub.chain()).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 0)
        
        main.value = 5
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], 5)
        
        sub.notify(value: 6)
        
        XCTAssertEqual(received.count, 3)
        XCTAssertEqual(received[2], 6)
        
        observer.invalidate()
    }
    
    func testMergeSubFetchable() {
        let main = Notifier<Int>()
        let sub = ValueHolder<Int>(0)
        
        var received: [Int] = []
        
        let observer = main.chain().merge(sub.chain()).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 0)
        
        sub.value = 7
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], 7)
        
        main.notify(value: 8)
        
        XCTAssertEqual(received.count, 3)
        XCTAssertEqual(received[2], 8)
        
        observer.invalidate()
    }
    
    func testMergeEachSendable() {
        let main = Notifier<Int>()
        let sub = Notifier<Int>()
        
        var received: [Int] = []
        
        let observer = main.chain().merge(sub.chain()).do { received.append($0) }.end()
        
        XCTAssertEqual(received.count, 0)
        
        main.notify(value: 1)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        sub.notify(value: 2)
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], 2)
        
        observer.invalidate()
    }
}
