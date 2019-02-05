//
//  ValueHolderTests.swift
//

import XCTest
import Chaining

class ValueHolderTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testHolder() {
        let holder = ValueHolder<Int>(0)
        
        XCTAssertEqual(holder.value, 0)
        
        holder.value = 1
        
        XCTAssertEqual(holder.value, 1)
        
        var received: Int?
        
        let observer = holder.chain().do { received = $0 }.sync()
        
        XCTAssertEqual(received, 1)
        
        holder.value = 2
        
        XCTAssertEqual(received, 2)
        
        observer.invalidate()
    }

    func testReceive() {
        let notifier = Notifier<Int>()
        let holder = ValueHolder<Int>(0)
        
        let observer = notifier.chain().receive(holder).end()
        
        XCTAssertEqual(holder.value, 0)
        
        notifier.notify(value: 4)
        
        XCTAssertEqual(holder.value, 4)
        
        observer.invalidate()
    }
    
    func testOptional() {
        let holder = ValueHolder<Int?>(nil)
        
        var received: [Int?] = []
        
        let observer = holder.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertNil(received[0])
        
        holder.value = 1
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], 1)
        
        observer.invalidate()
    }
}
