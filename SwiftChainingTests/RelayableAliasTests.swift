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
        let innerHolder = Holder<Int>(0)
        let relayableHolder = RelayableHolder<Holder<Int>>(innerHolder)
        let alias = Alias(relayableHolder)
        
        var events: [RelayableHolder<Holder<Int>>.Event] = []
        
        let observer = alias.chain().do { event in events.append(event) }.sync()
        
        XCTAssertEqual(events.count, 1)
        
        innerHolder.value = 1
        
        XCTAssertEqual(events.count, 2)
        
        let innerHolder2 = Holder<Int>(2)
        relayableHolder.value = innerHolder2
        
        XCTAssertEqual(events.count, 3)
        
        innerHolder.value = 10
        
        XCTAssertEqual(events.count, 3)
        
        innerHolder2.value = 3
        
        XCTAssertEqual(events.count, 4)
        
        observer.invalidate()
    }
    
    func testValue() {
        let innerHolder = Holder<Int>(0)
        let relayableHolder = RelayableHolder<Holder<Int>>(innerHolder)
        let alias = Alias(relayableHolder)
        
        XCTAssertEqual(alias.value, Holder<Int>(0))
        
        relayableHolder.value = Holder<Int>(1)
        
        XCTAssertEqual(alias.value, Holder<Int>(1))
    }
}
