//
//  AliasTests.swift
//

import XCTest
import Chaining

class AliasTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testSendable() {
        let sender = Notifier<Int>()
        let alias = Alias(sender)
        
        var received: [Int] = []
        
        let observer = alias.chain()?.do { received.append($0) }.end()
        
        sender.notify(value: 1)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        observer?.invalidate()
    }
    
    func testSyncable() {
        let holder = ValueHolder<Int>(0)
        let alias = Alias(holder)
        
        var received: [Int] = []
        
        let observer = alias.chain()?.do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 0)
        
        holder.value = 1
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], 1)
        
        observer?.invalidate()
    }
    
    func testValue() {
        let holder = ValueHolder<Int>(0)
        let alias = Alias(holder)
        
        XCTAssertEqual(alias.value(), 0)
        
        holder.value = 1
        
        XCTAssertEqual(alias.value(), 1)
    }
    
    func testSafeValueChainerReleased() {
        var alias: Alias<ValueHolder<Int>>?
        
        do {
            let holder = ValueHolder<Int>(0)
            alias = Alias(holder)
            
            XCTAssertEqual(alias?.safeValue(), 0)
            
            holder.value = 1
            
            XCTAssertEqual(alias?.safeValue(), 1)
        }
        
        XCTAssertNil(alias?.safeValue())
    }
    
    func testSafeValueCanFetchIsFalse() {
        var canFetch = true
        
        let fetcher = Fetcher<Int>({ 1 }, canFetch: { canFetch })
        let alias = Alias(fetcher)
        
        XCTAssertEqual(alias.safeValue(), 1)
        
        canFetch = false
        
        XCTAssertNil(alias.safeValue())
    }
}
