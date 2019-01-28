//
//  RelayableHolderTests.swift
//

import XCTest
import Chaining

class RelayableHolderTests: XCTestCase {
    override func setUp() {
    }

    override func tearDown() {
    }
    
    func testFetchableValue() {
        let innerHolder1 = ValueHolder<Int>(0)
        let holder = RelayableValueHolder<ValueHolder<Int>>(innerHolder1)

        var events: [RelayableValueHolder<ValueHolder<Int>>.Event] = []

        let observer = holder.chain().do { event in events.append(event) }.sync()

        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], .fetched(ValueHolder<Int>(0)))
        XCTAssertEqual(holder.value, ValueHolder<Int>(0))

        innerHolder1.value = 1

        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events[1], .relayed(1))
        XCTAssertEqual(holder.value, ValueHolder<Int>(1))

        let innerHolder2 = ValueHolder<Int>(2)
        holder.value = innerHolder2

        XCTAssertEqual(events.count, 3)
        XCTAssertEqual(events[2], .current(ValueHolder<Int>(2)))
        XCTAssertEqual(holder.value, ValueHolder<Int>(2))
        
        innerHolder1.value = 10
        
        XCTAssertEqual(events.count, 3)
        
        innerHolder2.value = 3

        XCTAssertEqual(events.count, 4)
        XCTAssertEqual(events[3], .relayed(3))
        XCTAssertEqual(holder.value, ValueHolder<Int>(3))
        
        observer.invalidate()
    }
    
    func testSendableValue() {
        let isEqualFetched = { (event: RelayableValueHolder<Notifier<Int>>.Event) -> Bool in
            if case .fetched = event {
                return true
            } else {
                return false
            }
        }
        
        let isEqualCurrent = { (event: RelayableValueHolder<Notifier<Int>>.Event) -> Bool in
            if case .current = event {
                return true
            } else {
                return false
            }
        }
        
        let isEqualRelayed = { (event: RelayableValueHolder<Notifier<Int>>.Event, expected: Int) -> Bool in
            if case .relayed(let value) = event {
                return value == expected
            } else {
                return false
            }
        }
        
        let innerNotifier1 = Notifier<Int>()
        let holder = RelayableValueHolder<Notifier<Int>>(innerNotifier1)
        
        var events: [RelayableValueHolder<Notifier<Int>>.Event] = []
        
        let observer = holder.chain().do { event in events.append(event) }.sync()
        
        XCTAssertEqual(events.count, 1)
        XCTAssertTrue(isEqualFetched(events[0]))
        
        innerNotifier1.notify(value: 1)
        
        XCTAssertEqual(events.count, 2)
        XCTAssertTrue(isEqualRelayed(events[1], 1))
        
        let innerNotifier2 = Notifier<Int>()
        holder.value = innerNotifier2
        
        XCTAssertEqual(events.count, 3)
        XCTAssertTrue(isEqualCurrent(events[2]))
        
        innerNotifier1.notify(value: 10)
        
        XCTAssertEqual(events.count, 3)
        
        innerNotifier2.notify(value: 3)
        
        XCTAssertEqual(events.count, 4)
        XCTAssertTrue(isEqualRelayed(events[3], 3))
        
        observer.invalidate()
    }
    
    func testReceive() {
        let notifier = Notifier<ValueHolder<Int>>()
        let holder = RelayableValueHolder<ValueHolder<Int>>(ValueHolder<Int>(0))
        
        let observer = notifier.chain().receive(holder).end()
        
        XCTAssertEqual(holder.value, ValueHolder<Int>(0))
        
        notifier.notify(value: ValueHolder<Int>(1))
        
        XCTAssertEqual(holder.value, ValueHolder<Int>(1))
        
        observer.invalidate()
    }
    
    func testEqual() {
        let holder1 = RelayableValueHolder(ValueHolder(1))
        let holder1b = RelayableValueHolder(ValueHolder(1))
        let holder2 = RelayableValueHolder(ValueHolder(2))
        
        XCTAssertEqual(holder1, holder1b)
        XCTAssertNotEqual(holder1, holder2)
    }
}
