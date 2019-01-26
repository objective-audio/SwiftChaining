//
//  RelayableArrayHolderTests.swift
//

import XCTest
import Chaining

class RelayableArrayHolderTests: XCTestCase {
    override func setUp() {
    }

    override func tearDown() {
    }
    
    func testReplaceElements() {
        let holder1 = Holder(1)
        let holder2 = Holder(2)
        let holder3 = Holder(3)
        
        let array = RelayableArrayHolder([holder1, holder2])
        
        XCTAssertEqual(array.rawArray.count, 2)
        XCTAssertEqual(array[0], Holder(1))
        XCTAssertEqual(array[1], Holder(2))
        
        array.replace([holder3])
        
        XCTAssertEqual(array.count, 1)
        XCTAssertEqual(array[0], Holder(3))
    }
    
    func testReplaceElement() {
        let holder1 = Holder(1)
        let holder2 = Holder(2)
        let holder3 = Holder(3)
        let holder2b = Holder(22)
        
        let array = RelayableArrayHolder([holder1, holder2, holder3])
        
        XCTAssertEqual(array.rawArray, [holder1, holder2, holder3])
        
        array.replace(holder2b, at: 1)
        
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array.rawArray, [holder1, holder2b, holder3])
    }
    
    func testSubscriptGet() {
        let array = RelayableArrayHolder([Holder(10)])
        
        XCTAssertEqual(array[0], Holder(10))
    }
    
    func testSubscriptSet() {
        let array = RelayableArrayHolder([Holder(10)])
        
        array[0] = Holder(11)
        
        XCTAssertEqual(array.rawArray, [Holder(11)])
    }
    
    func testEvent() {
        let array = RelayableArrayHolder([Holder(10), Holder(20)])
        
        var received: [RelayableArrayHolder<Holder<Int>>.Event] = []
        
        let observer = array.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        
        if case .fetched(let elements) = received[0] {
            XCTAssertEqual(elements, [Holder<Int>(10), Holder<Int>(20)])
        } else {
            XCTAssertTrue(false)
        }
        
        array.append(Holder(100))
        
        XCTAssertEqual(received.count, 2)
        
        if case .inserted(let index, let element) = received[1] {
            XCTAssertEqual(element, Holder(100))
            XCTAssertEqual(index, 2)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.rawArray, [Holder(10), Holder(20), Holder(100)])
        
        array.insert(Holder(200), at: 1)
        
        XCTAssertEqual(received.count, 3)
        
        if case .inserted(let index, let element) = received[2] {
            XCTAssertEqual(element, Holder(200))
            XCTAssertEqual(index, 1)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.rawArray, [Holder(10), Holder(200), Holder(20), Holder(100)])
        
        array.remove(at: 2)
        
        XCTAssertEqual(received.count, 4)
        
        if case .removed(let index, let element) = received[3] {
            XCTAssertEqual(element, Holder(20))
            XCTAssertEqual(index, 2)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.rawArray, [Holder(10), Holder(200), Holder(100)])
        
        array[0].value = 11
        
        XCTAssertEqual(received.count, 5)
        
        if case .relayed(let value, let index, let element) = received[4] {
            XCTAssertEqual(element, Holder(11))
            XCTAssertEqual(index, 0)
            XCTAssertEqual(value, 11)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.rawArray, [Holder(11), Holder(200), Holder(100)])
        
        array.replace(Holder(500), at: 1)
        
        XCTAssertEqual(received.count, 6)
        
        if case .replaced(let index, let element) = received[5] {
            XCTAssertEqual(element, Holder(500))
            XCTAssertEqual(index, 1)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.rawArray, [Holder(11), Holder(500), Holder(100)])
        
        array.replace([Holder(1000), Holder(999)])
        
        XCTAssertEqual(received.count, 7)
        
        if case .any(let elements) = received[6] {
            XCTAssertEqual(elements, [Holder(1000), Holder(999)])
        } else {
            XCTAssertTrue(false)
        }
        
        array[1].value = 998
        
        XCTAssertEqual(received.count, 8)
        
        if case .relayed(let value, let index, let element) = received[7] {
            XCTAssertEqual(element, Holder(998))
            XCTAssertEqual(index, 1)
            XCTAssertEqual(value, 998)
        } else {
            XCTAssertTrue(false)
        }
        
        array.removeAll()
        
        XCTAssertEqual(received.count, 9)
        
        if case .any(let elements) = received[8] {
            XCTAssertEqual(elements, [])
        } else {
            XCTAssertTrue(false)
        }
        
        observer.invalidate()
    }
    
    func testEventAfterInserted() {
        let array = RelayableArrayHolder([Holder("a")])
        
        array.insert(Holder("b"), at: 0)
        
        var received: [RelayableArrayHolder<Holder<String>>.Event] = []
        
        let observer = array.chain().do { received.append($0) }.end()
        
        array[1].value = "c"
        
        XCTAssertEqual(received.count, 1)
        
        if case .relayed(let value, let index, let element) = received[0] {
            XCTAssertEqual(value, "c")
            XCTAssertEqual(index, 1)
            XCTAssertEqual(element, Holder("c"))
        } else {
            XCTAssertTrue(false)
        }
        
        observer.invalidate()
    }
}
