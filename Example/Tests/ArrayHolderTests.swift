//
//  ArrayHolderTests.swift
//

import XCTest
import Chaining

class ArrayHolderTests: XCTestCase {
    var pool = ObserverPool()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        self.pool.invalidate()
        super.tearDown()
    }
    
    func testInit() {
        let array = ArrayHolder<Int>()
        
        XCTAssertEqual(array.rawArray, [])
    }
    
    func testReplaceElementsWithRelayable() {
        let array = ArrayHolder([10, 20])
        
        XCTAssertEqual(array.rawArray, [10, 20])
        
        array.replace([30, 40, 50])
        
        XCTAssertEqual(array.rawArray, [30, 40, 50])
    }
    
    func testReplaceElementsWithSendableValue() {
        let holder1 = Holder(1)
        let holder2 = Holder(2)
        let holder3 = Holder(3)
        
        let array = ArrayHolder([holder1, holder2])
        
        XCTAssertEqual(array.rawArray.count, 2)
        XCTAssertEqual(array[0], Holder(1))
        XCTAssertEqual(array[1], Holder(2))
        
        array.replace([holder3])
        
        XCTAssertEqual(array.count, 1)
        XCTAssertEqual(array[0], Holder(3))
    }
    
    func testReplaceElementWithRelayableValue() {
        let array = ArrayHolder([10, 20, 30])
        
        XCTAssertEqual(array.rawArray, [10, 20, 30])
        
        array.replace(200, at: 1)
        
        XCTAssertEqual(array.rawArray, [10, 200, 30])
    }
    
    func testReplaceElementWithSendableValue() {
        let holder1 = Holder(1)
        let holder2 = Holder(2)
        let holder3 = Holder(3)
        let holder2b = Holder(22)
        
        let array = ArrayHolder([holder1, holder2, holder3])
        
        XCTAssertEqual(array.rawArray, [holder1, holder2, holder3])
        
        array.replace(holder2b, at: 1)
        
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array.rawArray, [holder1, holder2b, holder3])
    }
    
    func testRemoveElement() {
        let array = ArrayHolder([1, 2, 3])
        
        let removed = array.remove(at: 1)
        
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual(array.rawArray, [1, 3])
        XCTAssertEqual(removed, 2)
    }
    
    func testRemoveAll() {
        let array = ArrayHolder([1, 2, 3])
        
        array.removeAll()
        
        XCTAssertEqual(array.count, 0)
    }
    
    func testReserveCapacity() {
        let array = ArrayHolder<Int>([])
        
        array.reserveCapacity(10)
        
        XCTAssertEqual(array.capacity, 10)
    }
    
    func testFirst() {
        let array = ArrayHolder<Int>([])
        
        XCTAssertNil(array.first)
        
        array.replace([1, 2])
        
        XCTAssertEqual(array.first, 1)
    }
    
    func testLast() {
        let array = ArrayHolder<Int>([])
        
        XCTAssertNil(array.last)
        
        array.replace([1, 2])
        
        XCTAssertEqual(array.last, 2)
    }
    
    func testCount() {
        let array = ArrayHolder([10, 20])
        
        XCTAssertEqual(array.count, 2)
        
        array.append(30)
        
        XCTAssertEqual(array.count, 3)
    }
    
    func testSubscriptGetWithRelayableValue() {
        let array = ArrayHolder([10])
        
        XCTAssertEqual(array[0], 10)
    }
    
    func testSubscriptGetWithSendableValue() {
        let array = ArrayHolder([Holder(10)])
        
        XCTAssertEqual(array[0], Holder(10))
    }
    
    func testSubscriptSetWithRelayableValue() {
        let array = ArrayHolder([10])
        
        array[0] = 11
        
        XCTAssertEqual(array.rawArray, [11])
    }
    
    func testSubscriptSetWithSendableValue() {
        let array = ArrayHolder([Holder(10)])
        
        array[0] = Holder(11)
        
        XCTAssertEqual(array.rawArray, [Holder(11)])
    }
    
    func testEventWithRelayableElements() {
        let array = ArrayHolder([10, 20])
        
        var received: [ArrayHolder<Int>.Event] = []
        
        self.pool += array.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        
        if case .fetched(let elements) = received[0] {
            XCTAssertEqual(elements, [10, 20])
        } else {
            XCTAssertTrue(false)
        }
        
        array.append(100)
        
        XCTAssertEqual(received.count, 2)
        
        if case .inserted(let index, let element) = received[1] {
            XCTAssertEqual(element, 100)
            XCTAssertEqual(index, 2)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.rawArray, [10, 20, 100])
        
        array.insert(200, at: 1)
        
        XCTAssertEqual(received.count, 3)
        
        if case .inserted(let index, let element) = received[2] {
            XCTAssertEqual(element, 200)
            XCTAssertEqual(index, 1)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.rawArray, [10, 200, 20, 100])
        
        array.remove(at: 2)
        
        XCTAssertEqual(received.count, 4)
        
        if case .removed(let index, let element) = received[3] {
            XCTAssertEqual(element, 20)
            XCTAssertEqual(index, 2)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.rawArray, [10, 200, 100])
        
        array.replace(500, at: 1)
        
        XCTAssertEqual(received.count, 5)
        
        if case .replaced(let index, let element) = received[4] {
            XCTAssertEqual(element, 500)
            XCTAssertEqual(index, 1)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.rawArray, [10, 500, 100])
        
        array.replace([1000, 999])
        
        XCTAssertEqual(received.count, 6)
        
        if case .any(let elements) = received[5] {
            XCTAssertEqual(elements, [1000, 999])
        } else {
            XCTAssertTrue(false)
        }
        
        array.removeAll()
        
        XCTAssertEqual(received.count, 7)
        
        if case .any(let elements) = received[6] {
            XCTAssertEqual(elements, [])
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.rawArray, [])
    }
    
    func testEventWithSendableElements() {
        let array = ArrayHolder([Holder(10), Holder(20)])
        
        var received: [ArrayHolder<Holder<Int>>.Event] = []
        
        self.pool += array.chain().do { received.append($0) }.sync()
        
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
    }
    
    func testEventAfterInserted() {
        let array = ArrayHolder([Holder("a")])
        
        array.insert(Holder("b"), at: 0)
        
        var received: [ArrayHolder<Holder<String>>.Event] = []
        
        self.pool += array.chain().do { received.append($0) }.end()
        
        array[1].value = "c"
        
        XCTAssertEqual(received.count, 1)
        
        if case .relayed(let value, let index, let element) = received[0] {
            XCTAssertEqual(value, "c")
            XCTAssertEqual(index, 1)
            XCTAssertEqual(element, Holder("c"))
        } else {
            XCTAssertTrue(false)
        }
    }
    
    func testEventAfterRemoveAllTwice() {
        let array = ArrayHolder([10, 20])
        
        var received: [ArrayHolder<Int>.Event] = []
        
        self.pool += array.chain().do { received.append($0) }.end()
        
        XCTAssertEqual(received.count, 0);
        
        array.removeAll()
        
        XCTAssertEqual(received.count, 1);
        
        array.removeAll()
        
        XCTAssertEqual(received.count, 1);
    }
}
