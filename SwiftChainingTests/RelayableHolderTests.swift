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
        let innerHolder1 = Holder<Int>(0)
        let holder = RelayableHolder<Holder<Int>>(innerHolder1)

        var events: [RelayableHolder<Holder<Int>>.Event] = []

        let observer = holder.chain().do { event in events.append(event) }.sync()

        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0], .current(Holder<Int>(0)))
        XCTAssertEqual(holder.value, Holder<Int>(0))

        innerHolder1.value = 1

        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events[1], .relayed(1))
        XCTAssertEqual(holder.value, Holder<Int>(1))

        let innerHolder2 = Holder<Int>(2)
        holder.value = innerHolder2

        XCTAssertEqual(events.count, 3)
        XCTAssertEqual(events[2], .current(Holder<Int>(2)))
        XCTAssertEqual(holder.value, Holder<Int>(2))
        
        innerHolder1.value = 10
        
        XCTAssertEqual(events.count, 3)
        
        innerHolder2.value = 3

        XCTAssertEqual(events.count, 4)
        XCTAssertEqual(events[3], .relayed(3))
        XCTAssertEqual(holder.value, Holder<Int>(3))
        
        observer.invalidate()
    }
    
    func testSendableValue() {
        let isEqualCurrent = { (event: RelayableHolder<Notifier<Int>>.Event) -> Bool in
            if case .current = event {
                return true
            } else {
                return false
            }
        }
        
        let isEqualRelayed = { (event: RelayableHolder<Notifier<Int>>.Event, expected: Int) -> Bool in
            if case .relayed(let value) = event {
                return value == expected
            } else {
                return false
            }
        }
        
        let innerNotifier1 = Notifier<Int>()
        let holder = RelayableHolder<Notifier<Int>>(innerNotifier1)
        
        var events: [RelayableHolder<Notifier<Int>>.Event] = []
        
        let observer = holder.chain().do { event in events.append(event) }.sync()
        
        XCTAssertEqual(events.count, 1)
        XCTAssertTrue(isEqualCurrent(events[0]))
        
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
}
