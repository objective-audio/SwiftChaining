//
//  PairTests.swift
//

import XCTest
import Chaining

class TupleTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEachFetchable() {
        let main = ValueHolder<Int>(1)
        let sub = ValueHolder<String>("2")
        
        var received: [(Int?, String?)] = []
        
        let observer = main.chain().tuple(sub.chain()).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[0].0, 1)
        XCTAssertNil(received[0].1)
        XCTAssertNil(received[1].0)
        XCTAssertEqual(received[1].1, "2")
        
        observer.invalidate()
    }
    
    func testMainFetchable() {
        let main = ValueHolder<Int>(0)
        let sub = Notifier<String>()
        
        var received: [(Int?, String?)] = []
        
        let observer = main.chain().tuple(sub.chain()).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].0, 0)
        XCTAssertNil(received[0].1)
        
        main.value = 1
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1].0, 1)
        XCTAssertNil(received[1].1)
        
        sub.notify(value: "2")
        
        XCTAssertEqual(received.count, 3)
        XCTAssertNil(received[2].0)
        XCTAssertEqual(received[2].1, "2")
        
        observer.invalidate()
    }
    
    func testSubFetchable() {
        let main = Notifier<Int>()
        let sub = ValueHolder<String>("")
        
        var received: [(Int?, String?)] = []
        
        let observer = main.chain().tuple(sub.chain()).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertNil(received[0].0)
        XCTAssertEqual(received[0].1, "")
        
        main.notify(value: 1)
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1].0, 1)
        XCTAssertNil(received[1].1)
        
        sub.value = "2"
        
        XCTAssertEqual(received.count, 3)
        XCTAssertNil(received[2].0)
        XCTAssertEqual(received[2].1, "2")
        
        observer.invalidate()
    }
    
    func testNoFetchable() {
        let main = Notifier<Int>()
        let sub = Notifier<String>()
        
        var received: [(Int?, String?)] = []
        
        let observer = main.chain().tuple(sub.chain()).do { received.append($0) }.end()
        
        XCTAssertEqual(received.count, 0)
        
        main.notify(value: 1)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].0, 1)
        XCTAssertNil(received[0].1)
        
        sub.notify(value: "2")
        
        XCTAssertEqual(received.count, 2)
        XCTAssertNil(received[1].0)
        XCTAssertEqual(received[1].1, "2")
        
        observer.invalidate()
    }
}
