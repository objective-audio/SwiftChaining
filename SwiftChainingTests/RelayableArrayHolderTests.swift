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
    
    func testMove() {
        let array = RelayableArrayHolder([ValueHolder(1), ValueHolder(2), ValueHolder(3)])
        
        array.move(at: 1, to: 0)
        
        XCTAssertEqual(array.raw, [ValueHolder(2), ValueHolder(1), ValueHolder(3)])
        
        array.move(at: 1, to: 2)
        
        XCTAssertEqual(array.raw, [ValueHolder(2), ValueHolder(3), ValueHolder(1)])
    }
    
    func testSetElements() {
        let holder1 = ValueHolder(1)
        let holder2 = ValueHolder(2)
        let holder3 = ValueHolder(3)
        
        let array = RelayableArrayHolder([holder1, holder2])
        
        XCTAssertEqual(array.raw.count, 2)
        XCTAssertEqual(array[0], ValueHolder(1))
        XCTAssertEqual(array[1], ValueHolder(2))
        
        array.set([holder3])
        
        XCTAssertEqual(array.count, 1)
        XCTAssertEqual(array[0], ValueHolder(3))
    }
    
    func testReplaceElement() {
        let holder1 = ValueHolder(1)
        let holder2 = ValueHolder(2)
        let holder3 = ValueHolder(3)
        let holder2b = ValueHolder(22)
        
        let array = RelayableArrayHolder([holder1, holder2, holder3])
        
        XCTAssertEqual(array.raw, [holder1, holder2, holder3])
        
        array.replace(holder2b, at: 1)
        
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array.raw, [holder1, holder2b, holder3])
    }
    
    func testSubscriptGet() {
        let array = RelayableArrayHolder([ValueHolder(10)])
        
        XCTAssertEqual(array[0], ValueHolder(10))
    }
    
    func testSubscriptSet() {
        let array = RelayableArrayHolder([ValueHolder(10)])
        
        array[0] = ValueHolder(11)
        
        XCTAssertEqual(array.raw, [ValueHolder(11)])
    }
    
    func testEvent() {
        let array = RelayableArrayHolder([ValueHolder(10), ValueHolder(20)])
        
        var received: [RelayableArrayHolder<ValueHolder<Int>>.Event] = []
        
        let observer = array.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        
        if case .fetched(let elements) = received[0] {
            XCTAssertEqual(elements, [ValueHolder<Int>(10), ValueHolder<Int>(20)])
        } else {
            XCTAssertTrue(false)
        }
        
        array.append(ValueHolder(100))
        
        XCTAssertEqual(received.count, 2)
        
        if case .inserted(let index, let element) = received[1] {
            XCTAssertEqual(element, ValueHolder(100))
            XCTAssertEqual(index, 2)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.raw, [ValueHolder(10), ValueHolder(20), ValueHolder(100)])
        
        array.insert(ValueHolder(200), at: 1)
        
        XCTAssertEqual(received.count, 3)
        
        if case .inserted(let index, let element) = received[2] {
            XCTAssertEqual(element, ValueHolder(200))
            XCTAssertEqual(index, 1)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.raw, [ValueHolder(10), ValueHolder(200), ValueHolder(20), ValueHolder(100)])
        
        array.remove(at: 2)
        
        XCTAssertEqual(received.count, 4)
        
        if case .removed(let index, let element) = received[3] {
            XCTAssertEqual(element, ValueHolder(20))
            XCTAssertEqual(index, 2)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.raw, [ValueHolder(10), ValueHolder(200), ValueHolder(100)])
        
        array[0].value = 11
        
        XCTAssertEqual(received.count, 5)
        
        if case .relayed(let value, let index, let element) = received[4] {
            XCTAssertEqual(element, ValueHolder(11))
            XCTAssertEqual(index, 0)
            XCTAssertEqual(value, 11)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.raw, [ValueHolder(11), ValueHolder(200), ValueHolder(100)])
        
        array.replace(ValueHolder(500), at: 1)
        
        XCTAssertEqual(received.count, 6)
        
        if case .replaced(let index, let element) = received[5] {
            XCTAssertEqual(element, ValueHolder(500))
            XCTAssertEqual(index, 1)
        } else {
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(array.raw, [ValueHolder(11), ValueHolder(500), ValueHolder(100)])
        
        array.move(at: 1, to: 0)
        
        XCTAssertEqual(received.count, 7)
        
        if case .moved(let from, let to, let element) = received[6] {
            XCTAssertEqual(element, ValueHolder(500))
            XCTAssertEqual(from, 1)
            XCTAssertEqual(to, 0)
        } else {
            XCTAssertTrue(false)
        }
        
        array.set([ValueHolder(1000), ValueHolder(999)])
        
        XCTAssertEqual(received.count, 8)
        
        if case .set(let elements) = received[7] {
            XCTAssertEqual(elements, [ValueHolder(1000), ValueHolder(999)])
        } else {
            XCTAssertTrue(false)
        }
        
        array[1].value = 998
        
        XCTAssertEqual(received.count, 9)
        
        if case .relayed(let value, let index, let element) = received[8] {
            XCTAssertEqual(element, ValueHolder(998))
            XCTAssertEqual(index, 1)
            XCTAssertEqual(value, 998)
        } else {
            XCTAssertTrue(false)
        }
        
        array.removeAll()
        
        XCTAssertEqual(received.count, 10)
        
        if case .set(let elements) = received[9] {
            XCTAssertEqual(elements, [])
        } else {
            XCTAssertTrue(false)
        }
        
        observer.invalidate()
    }
    
    func testEventAfterInserted() {
        let array = RelayableArrayHolder([ValueHolder("a")])
        
        array.insert(ValueHolder("b"), at: 0)
        
        var received: [RelayableArrayHolder<ValueHolder<String>>.Event] = []
        
        let observer = array.chain().do { received.append($0) }.end()
        
        array[1].value = "c"
        
        XCTAssertEqual(received.count, 1)
        
        if case .relayed(let value, let index, let element) = received[0] {
            XCTAssertEqual(value, "c")
            XCTAssertEqual(index, 1)
            XCTAssertEqual(element, ValueHolder("c"))
        } else {
            XCTAssertTrue(false)
        }
        
        observer.invalidate()
    }
    
    func testReceivable() {
        let notifier = Notifier<ArrayAction<ValueHolder<Int>>>()
        let array = RelayableArrayHolder([ValueHolder(10), ValueHolder(20)])
        
        let observer = notifier.chain().sendTo(array).end()
        
        notifier.notify(value: .insert(ValueHolder(100), at: 2))
        
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array[2], ValueHolder(100))
        
        notifier.notify(value: .move(at: 0, to: 1))
        
        XCTAssertEqual(array[0], ValueHolder(20))
        XCTAssertEqual(array[1], ValueHolder(10))
        XCTAssertEqual(array[2], ValueHolder(100))
        
        notifier.notify(value: .remove(at: 1))
        
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual(array[0], ValueHolder(20))
        XCTAssertEqual(array[1], ValueHolder(100))
        
        notifier.notify(value: .replace(ValueHolder(500), at: 0))
        
        XCTAssertEqual(array[0], ValueHolder(500))
        
        notifier.notify(value: .set([ValueHolder(1000), ValueHolder(1001)]))
        
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual(array[0], ValueHolder(1000))
        XCTAssertEqual(array[1], ValueHolder(1001))
        
        observer.invalidate()
    }
}
