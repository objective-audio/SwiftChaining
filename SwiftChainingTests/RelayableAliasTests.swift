//
//  RelayableAliasTests.swift
//

import XCTest
import Chaining

class RelayableAliasTests: XCTestCase {
    override func setUp() {
    }

    override func tearDown() {
    }

    func testChain() {
        let innerHolder = ValueHolder<Int>(0)
        let relayableHolder = RelayableValueHolder<ValueHolder<Int>>(innerHolder)
        let alias = Alias(relayableHolder)
        
        var events: [RelayableValueHolder<ValueHolder<Int>>.Event] = []
        
        let observer = alias.chain().do { event in events.append(event) }.sync()
        
        XCTAssertEqual(events.count, 1)
        
        innerHolder.value = 1
        
        XCTAssertEqual(events.count, 2)
        
        let innerHolder2 = ValueHolder<Int>(2)
        relayableHolder.value = innerHolder2
        
        XCTAssertEqual(events.count, 3)
        
        innerHolder.value = 10
        
        XCTAssertEqual(events.count, 3)
        
        innerHolder2.value = 3
        
        XCTAssertEqual(events.count, 4)
        
        observer.invalidate()
    }
    
    func testValue() {
        let innerHolder = ValueHolder<Int>(0)
        let relayableHolder = RelayableValueHolder<ValueHolder<Int>>(innerHolder)
        let alias = Alias(relayableHolder)
        
        XCTAssertEqual(alias.value, ValueHolder<Int>(0))
        
        relayableHolder.value = ValueHolder<Int>(1)
        
        XCTAssertEqual(alias.value, ValueHolder<Int>(1))
    }
}
