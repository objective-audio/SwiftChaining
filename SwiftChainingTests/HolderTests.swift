//
//  HolderTests.swift
//

import XCTest
import Chaining

class HolderTests: XCTestCase {
    var pool = ObserverPool()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        self.pool.invalidate()
        super.tearDown()
    }

    func testHolder() {
        let holder = Holder<Int>(0)
        
        XCTAssertEqual(holder.value, 0)
        
        holder.value = 1
        
        XCTAssertEqual(holder.value, 1)
        
        var received: Int?
        
        self.pool += holder.chain().do { received = $0 }.sync()
        
        XCTAssertEqual(received, 1)
        
        holder.value = 2
        
        XCTAssertEqual(received, 2)
    }

    func testHolderReceive() {
        let notifier = Notifier<Int>()
        let holder = Holder<Int>(0)
        
        self.pool += notifier.chain().receive(holder).end()
        
        XCTAssertEqual(holder.value, 0)
        
        notifier.notify(value: 4)
        
        XCTAssertEqual(holder.value, 4)
    }
}
