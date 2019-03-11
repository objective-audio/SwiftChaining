//
//  EventableValueHolderTests.swift
//

import XCTest
import Chaining

class EventableValueHolderTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
    
    func testValue() {
        let holder = EventableValueHolder(0)
        
        XCTAssertEqual(holder.value, 0)
        
        holder.value = 1
        
        XCTAssertEqual(holder.value, 1)
    }
    
    func testEventEquatable() {
        let holder = EventableValueHolder(0)
        
        var received: [EventableValueHolder<Int>.Event] = []
        
        let observer = holder.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], .fetched(0))
        
        holder.value = 1
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], .current(1))
        
        holder.value = 1
        
        XCTAssertEqual(received.count, 2)
        
        observer.invalidate()
    }
    
    func testEventNonEquatable() {
        struct NonEquatable {
            let raw: Int
        }
        
        let holder = EventableValueHolder(NonEquatable(raw: 0))
        
        var received: [EventableValueHolder<NonEquatable>.Event] = []
        
        let observer = holder.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        
        if case .fetched(let value) = received[0] {
            XCTAssertEqual(value.raw, 0)
        } else {
            XCTFail()
        }
        
        holder.value = NonEquatable(raw: 1)
        
        XCTAssertEqual(received.count, 2)
        
        if case .current(let value) = received[1] {
            XCTAssertEqual(value.raw, 1)
        } else {
            XCTFail()
        }
        
        holder.value = NonEquatable(raw: 1)
        
        XCTAssertEqual(received.count, 3)
        
        if case .current(let value) = received[1] {
            XCTAssertEqual(value.raw, 1)
        } else {
            XCTFail()
        }
        
        observer.invalidate()
    }
    
    func testEqual() {
        let holder1a = EventableValueHolder(1)
        let holder1b = EventableValueHolder(1)
        let holder2 = EventableValueHolder(2)
        
        XCTAssertEqual(holder1a, holder1b)
        XCTAssertNotEqual(holder1a, holder2)
    }
    
    func testEventEqual() {
        let fetched1a = EventableValueHolder.Event.fetched(1)
        let fetched1b = EventableValueHolder.Event.fetched(1)
        let fetched2 = EventableValueHolder.Event.fetched(2)
        let current1a = EventableValueHolder.Event.current(1)
        let current1b = EventableValueHolder.Event.current(1)
        let current2 = EventableValueHolder.Event.current(2)
        
        XCTAssertEqual(fetched1a, fetched1b)
        XCTAssertNotEqual(fetched1a, fetched2)
        XCTAssertEqual(current1a, current1b)
        XCTAssertNotEqual(current1a, current2)
        XCTAssertNotEqual(fetched1a, current1a)
    }
    
    func testReceivable() {
        let notifier = Notifier<Int>()
        let holder = EventableValueHolder(0)
        
        let observer = notifier.chain().sendTo(holder).end()
        
        XCTAssertEqual(holder.value, 0)
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(holder.value, 1)
        
        observer.invalidate()
    }
}
