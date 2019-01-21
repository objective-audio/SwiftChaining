//
//  ToTests.swift
//

import XCTest
import Chaining

class ToTests: XCTestCase {
    var pool = ObserverPool()
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        self.pool.invalidate()
        super.tearDown()
    }

    func testToValue() {
        let notifier = Notifier<Int>()
        
        var received: String?
        
        self.pool += notifier.chain().to("text").do { received = $0 }.end()
        
        XCTAssertNil(received)
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(received, "text")
    }
    
    func testToVoid() {
        let notifier = Notifier<Int>()
        
        var received: Bool = false
        
        self.pool += notifier.chain().toVoid().do { received = true }.end()
        
        XCTAssertFalse(received)
        
        notifier.notify(value: 1)
        
        XCTAssertTrue(received)
    }

}
