//
//  MergeTests.swift
//

import XCTest
import SwiftChaining

class MergeTests: XCTestCase {
    var pool = ObserverPool()
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        self.pool.invalidate()
        super.tearDown()
    }

    func testMergeToMain() {
        let main = Holder<Int>(0)
        let sub = Notifier<Int>()
        
        var received: Int?
        
        self.pool += main.chain().merge(sub.chain()).do { received = $0 }.sync()
        
        XCTAssertEqual(received, 0)
        
        main.value = 5
        
        XCTAssertEqual(received, 5)
        
        sub.notify(value: 6)
        
        XCTAssertEqual(received, 6)
    }
    
    func testMergeToSub() {
        let main = Notifier<Int>()
        let sub = Holder<Int>(0)
        
        var received: Int?
        
        self.pool += main.chain().merge(sub.chain()).do { received = $0 }.sync()
        
        XCTAssertEqual(received, 0)
        
        sub.value = 7
        
        XCTAssertEqual(received, 7)
        
        main.notify(value: 8)
        
        XCTAssertEqual(received, 8)
    }
    
    func testMergeToMainUnFetched() {
        let main = Notifier<Int>()
        let sub = Notifier<Int>()
        
        var received: Int?
        
        let observer = main.chain().merge(sub.chain()).do { received = $0 }.end()
        
        self.pool += observer
        
        XCTAssertNil(received)
        
        main.notify(value: 1)
        
        XCTAssertEqual(received, 1)
        
        sub.notify(value: 2)
        
        XCTAssertEqual(received, 2)
    }

}
