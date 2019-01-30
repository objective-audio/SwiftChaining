//
//  ArrayHolderTests.swift
//

import XCTest
import Chaining

class ArrayHolderTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInit() {
        let array = ArrayHolder<Int>()
        
        XCTAssertEqual(array.raw, [])
    }
    
    func testReplaceElements() {
        let array = ArrayHolder([10, 20])
        
        XCTAssertEqual(array.raw, [10, 20])
        
        array.replace([30, 40, 50])
        
        XCTAssertEqual(array.raw, [30, 40, 50])
    }
    
    func testReplaceElementWithRelayableValue() {
        let array = ArrayHolder([10, 20, 30])
        
        XCTAssertEqual(array.raw, [10, 20, 30])
        
        array.replace(200, at: 1)
        
        XCTAssertEqual(array.raw, [10, 200, 30])
    }
    
    
    
    func testRemoveElement() {
        let array = ArrayHolder([1, 2, 3])
        
        let removed = array.remove(at: 1)
        
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual(array.raw, [1, 3])
        XCTAssertEqual(removed, 2)
    }
    
    func testRemoveAll() {
        let array = ArrayHolder([1, 2, 3])
        
        array.removeAll()
        
        XCTAssertEqual(array.count, 0)
    }
    
    func testMove() {
        let array = ArrayHolder([1, 2, 3])
        
        array.move(at: 0, to: 1)
        
        XCTAssertEqual(array.raw, [2, 1, 3])
        
        array.move(at: 1, to: 2)
        
        XCTAssertEqual(array.raw, [2, 3, 1])
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
    
    func testSubscriptGet() {
        let array = ArrayHolder([10])
        
        XCTAssertEqual(array[0], 10)
    }
    
    func testSubscriptSetWithRelayableValue() {
        let array = ArrayHolder([10])
        
        array[0] = 11
        
        XCTAssertEqual(array.raw, [11])
    }
    
    func testEvent() {
        let array = ArrayHolder([10, 20])
        
        var received: [ArrayHolder<Int>.Event] = []
        
        let observer = array.chain().do { received.append($0) }.sync()
        
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
        
        XCTAssertEqual(array.raw, [10, 20, 100])
        
        array.insert(200, at: 1)
        
        XCTAssertEqual(received.count, 3)
        
        if case .inserted(let index, let element) = received[2] {
            XCTAssertEqual(element, 200)
            XCTAssertEqual(index, 1)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.raw, [10, 200, 20, 100])
        
        array.remove(at: 2)
        
        XCTAssertEqual(received.count, 4)
        
        if case .removed(let index, let element) = received[3] {
            XCTAssertEqual(element, 20)
            XCTAssertEqual(index, 2)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.raw, [10, 200, 100])
        
        array.replace(500, at: 1)
        
        XCTAssertEqual(received.count, 5)
        
        if case .replaced(let index, let element) = received[4] {
            XCTAssertEqual(element, 500)
            XCTAssertEqual(index, 1)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.raw, [10, 500, 100])
        
        array.move(at: 0, to: 1)
        
        XCTAssertEqual(received.count, 6)
        
        if case .moved(let from, let to, let element) = received[5] {
            XCTAssertEqual(element, 10)
            XCTAssertEqual(from, 0)
            XCTAssertEqual(to, 1)
        } else {
            XCTAssertTrue(false)
        }
        
        array.replace([1000, 999])
        
        XCTAssertEqual(received.count, 7)
        
        if case .any(let elements) = received[6] {
            XCTAssertEqual(elements, [1000, 999])
        } else {
            XCTAssertTrue(false)
        }
        
        array.removeAll()
        
        XCTAssertEqual(received.count, 8)
        
        if case .any(let elements) = received[7] {
            XCTAssertEqual(elements, [])
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.raw, [])
        
        observer.invalidate()
    }
    
    func testEventAfterRemoveAllTwice() {
        let array = ArrayHolder([10, 20])
        
        var received: [ArrayHolder<Int>.Event] = []
        
        let observer = array.chain().do { received.append($0) }.end()
        
        XCTAssertEqual(received.count, 0);
        
        array.removeAll()
        
        XCTAssertEqual(received.count, 1);
        
        array.removeAll()
        
        XCTAssertEqual(received.count, 1);
        
        observer.invalidate()
    }
}
