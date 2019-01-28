//
//  RelayableDictionaryHolderTests.swift
//

import XCTest
import Chaining

class RelayableDictionaryHolderTests: XCTestCase {
    override func setUp() {
    }

    override func tearDown() {
    }
    
    func testSetDictionary() {
        let holder1 = ValueHolder(1)
        let holder2 = ValueHolder(2)
        let holder3 = ValueHolder(3)
        
        let dictionary = RelayableDictionaryHolder([1: holder1, 2: holder2])
        
        XCTAssertEqual(dictionary.rawDictionary.count, 2)
        XCTAssertEqual(dictionary[1], ValueHolder(1))
        XCTAssertEqual(dictionary[2], ValueHolder(2))
        
        dictionary.set([3: holder3])
        
        XCTAssertEqual(dictionary.count, 1)
        XCTAssertEqual(dictionary[3], ValueHolder(3))
    }
    
    func testReplaceValue() {
        let holder1 = ValueHolder(1)
        let holder2 = ValueHolder(2)
        let holder3 = ValueHolder(3)
        let holder2b = ValueHolder(22)
        let holder3b = ValueHolder(33)
        
        let dictionary = RelayableDictionaryHolder([1: holder1, 2: holder2, 3: holder3])
        
        XCTAssertEqual(dictionary.rawDictionary, [1: holder1, 2: holder2, 3: holder3])
        
        dictionary.replace(key: 2, value: holder2b)
        
        XCTAssertEqual(dictionary.count, 3)
        XCTAssertEqual(dictionary.rawDictionary, [1: holder1, 2: holder2b, 3: holder3])
        
        dictionary[3] = holder3b
        
        XCTAssertEqual(dictionary.rawDictionary, [1: holder1, 2: holder2b, 3: holder3b])
    }
    
    func testRemoveValue() {
        let array = RelayableDictionaryHolder([1: ValueHolder("1"), 2: ValueHolder("2"), 3: ValueHolder("3")])
        
        let removed2 = array.removeValue(forKey: 2)
        
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual(array.rawDictionary, [1: ValueHolder("1"), 3: ValueHolder("3")])
        XCTAssertEqual(removed2, ValueHolder("2"))
        
        let removed4 = array.removeValue(forKey: 4)
        
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual(array.rawDictionary, [1: ValueHolder("1"), 3: ValueHolder("3")])
        XCTAssertNil(removed4)
    }
    
    func testRemoveAll() {
        let dictionary = RelayableDictionaryHolder([1: ValueHolder("1"), 2: ValueHolder("2"), 3: ValueHolder("3")])
        
        dictionary.removeAll()
        
        XCTAssertEqual(dictionary.count, 0)
    }
    
    func testReserveCapacity() {
        let dictionary = RelayableDictionaryHolder<Int, ValueHolder<Int>>([:])
        
        dictionary.reserveCapacity(10)
        
        XCTAssertGreaterThanOrEqual(dictionary.capacity, 10)
    }
    
    func testSubscriptGet() {
        let dictionary = RelayableDictionaryHolder([10: ValueHolder(10)])
        
        XCTAssertEqual(dictionary[10], ValueHolder(10))
        XCTAssertNil(dictionary[20])
    }
    
    func testSubscriptSet() {
        let dictionary = RelayableDictionaryHolder([10: ValueHolder(10)])
        
        dictionary[20] = ValueHolder(20)
        
        XCTAssertEqual(dictionary.rawDictionary, [10: ValueHolder(10), 20: ValueHolder(20)])
        
        dictionary[10] = ValueHolder(100)
        
        XCTAssertEqual(dictionary.rawDictionary, [10: ValueHolder(100), 20: ValueHolder(20)])
        
        dictionary[20] = nil
        
        XCTAssertEqual(dictionary.rawDictionary, [10: ValueHolder(100)])
    }
    
    func testEvent() {
        let dictionary = RelayableDictionaryHolder([10: ValueHolder(10), 20: ValueHolder(20)])
        
        var received: [RelayableDictionaryHolder<Int, ValueHolder<Int>>.Event] = []
        
        let observer = dictionary.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        
        if case .fetched(let elements) = received[0] {
            XCTAssertEqual(elements, [10: ValueHolder<Int>(10), 20: ValueHolder<Int>(20)])
        } else {
            XCTAssertTrue(false)
        }
        
        dictionary.insert(key: 100, value: ValueHolder(100))
        
        XCTAssertEqual(received.count, 2)
        
        if case .inserted(let key, let value) = received[1] {
            XCTAssertEqual(value, ValueHolder(100))
            XCTAssertEqual(key, 100)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(dictionary.rawDictionary, [10: ValueHolder(10), 20: ValueHolder(20), 100: ValueHolder(100)])
        
        dictionary.removeValue(forKey: 20)
        
        XCTAssertEqual(received.count, 3)
        
        if case .removed(let key, let value) = received[2] {
            XCTAssertEqual(value, ValueHolder(20))
            XCTAssertEqual(key, 20)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(dictionary.rawDictionary, [10: ValueHolder(10), 100: ValueHolder(100)])
        
        dictionary[10]?.value = 11
        
        XCTAssertEqual(received.count, 4)
        
        if case .relayed(let relayedValue, let key, let value) = received[3] {
            XCTAssertEqual(value, ValueHolder(11))
            XCTAssertEqual(key, 10)
            XCTAssertEqual(relayedValue, 11)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(dictionary.rawDictionary, [10: ValueHolder(11), 100: ValueHolder(100)])
        
        dictionary.replace(key: 100, value: ValueHolder(500))
        
        XCTAssertEqual(received.count, 5)
        
        if case .replaced(let key, let value) = received[4] {
            XCTAssertEqual(value, ValueHolder(500))
            XCTAssertEqual(key, 100)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(dictionary.rawDictionary, [10: ValueHolder(11), 100: ValueHolder(500)])
        
        dictionary.set([1000: ValueHolder(1000), 999: ValueHolder(999)])
        
        XCTAssertEqual(received.count, 6)
        
        if case .any(let dictionary) = received[5] {
            XCTAssertEqual(dictionary, [1000: ValueHolder(1000), 999: ValueHolder(999)])
        } else {
            XCTAssertTrue(false)
        }
        
        dictionary.removeAll()
        
        XCTAssertEqual(received.count, 7)
        
        if case .any(let dictionary) = received[6] {
            XCTAssertEqual(dictionary, [:])
        } else {
            XCTAssertTrue(false)
        }
        
        observer.invalidate()
    }
}
