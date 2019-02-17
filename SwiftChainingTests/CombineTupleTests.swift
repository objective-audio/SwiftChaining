//
//  CombineTupleTests.swift
//

import XCTest
import Chaining

class CombineTupleTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testEachFetchable() {
        let main = ValueHolder(0)
        let sub1 = ValueHolder("1")
        let sub2 = ValueHolder(2.0)
        
        var received: [(Int, String, Double)] = []
        
        let observer = main.chain().combine(sub1.chain(), sub2.chain()).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].0, 0)
        XCTAssertEqual(received[0].1, "1")
        XCTAssertEqual(received[0].2, 2.0)
        
        observer.invalidate()
    }
    
    func testMainFetchable() {
        let main = ValueHolder(0)
        let sub1 = Notifier<String>()
        let sub2 = Notifier<Double>()
        
        var received: [(Int, String, Double)] = []
        
        let observer = main.chain().combine(sub1.chain(), sub2.chain()).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 0)
        
        sub1.notify(value: "1")
        
        XCTAssertEqual(received.count, 0)
        
        sub2.notify(value: 2.0)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].0, 0)
        XCTAssertEqual(received[0].1, "1")
        XCTAssertEqual(received[0].2, 2.0)
        
        observer.invalidate()
    }
    
    func testMainSub1Fetchable() {
        let main = ValueHolder(0)
        let sub1 = ValueHolder("1")
        let sub2 = Notifier<Double>()
        
        var received: [(Int, String, Double)] = []
        
        let observer = main.chain().combine(sub1.chain(), sub2.chain()).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 0)
        
        sub2.notify(value: 2.0)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].0, 0)
        XCTAssertEqual(received[0].1, "1")
        XCTAssertEqual(received[0].2, 2.0)
        
        observer.invalidate()
    }
    
    func testMainSub2Fetchable() {
        let main = ValueHolder(0)
        let sub1 = Notifier<String>()
        let sub2 = ValueHolder(2.0)
        
        var received: [(Int, String, Double)] = []
        
        let observer = main.chain().combine(sub1.chain(), sub2.chain()).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 0)
        
        sub1.notify(value: "1")
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].0, 0)
        XCTAssertEqual(received[0].1, "1")
        XCTAssertEqual(received[0].2, 2.0)
        
        observer.invalidate()
    }
    
    func testSub1Fetchable() {
        let main = Notifier<Int>()
        let sub1 = ValueHolder("1")
        let sub2 = Notifier<Double>()
        
        var received: [(Int, String, Double)] = []
        
        let observer = main.chain().combine(sub1.chain(), sub2.chain()).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 0)
        
        main.notify(value: 0)
        
        XCTAssertEqual(received.count, 0)
        
        sub2.notify(value: 2.0)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].0, 0)
        XCTAssertEqual(received[0].1, "1")
        XCTAssertEqual(received[0].2, 2.0)
        
        observer.invalidate()
    }
    
    func testSub2Fetchable() {
        let main = Notifier<Int>()
        let sub1 = Notifier<String>()
        let sub2 = ValueHolder(2.0)
        
        var received: [(Int, String, Double)] = []
        
        let observer = main.chain().combine(sub1.chain(), sub2.chain()).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 0)
        
        main.notify(value: 0)
        
        XCTAssertEqual(received.count, 0)
        
        sub1.notify(value: "1")
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].0, 0)
        XCTAssertEqual(received[0].1, "1")
        XCTAssertEqual(received[0].2, 2.0)
        
        observer.invalidate()
    }
    
    func testSub1Sub2Fetchable() {
        let main = Notifier<Int>()
        let sub1 = ValueHolder("1")
        let sub2 = ValueHolder(2.0)
        
        var received: [(Int, String, Double)] = []
        
        let observer = main.chain().combine(sub1.chain(), sub2.chain()).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 0)
        
        main.notify(value: 0)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].0, 0)
        XCTAssertEqual(received[0].1, "1")
        XCTAssertEqual(received[0].2, 2.0)
        
        observer.invalidate()
    }
    
    func testEachSendable() {
        let main = Notifier<Int>()
        let sub1 = Notifier<String>()
        let sub2 = Notifier<Double>()
        
        var received: [(Int, String, Double)] = []
        
        let observer = main.chain().combine(sub1.chain(), sub2.chain()).do { received.append($0) }.end()
        
        main.notify(value: 0)
        
        XCTAssertEqual(received.count, 0)
        
        sub1.notify(value: "1")
        
        XCTAssertEqual(received.count, 0)
        
        sub2.notify(value: 2.0)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].0, 0)
        XCTAssertEqual(received[0].1, "1")
        XCTAssertEqual(received[0].2, 2.0)
        
        observer.invalidate()
    }
}
