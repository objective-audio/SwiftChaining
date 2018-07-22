//
//  NotifierTests.swift
//

import XCTest
import SwiftChaining

class NotifierTests: XCTestCase {
    var pool = ObserverPool()
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        self.pool.invalidate()
        super.tearDown()
    }

    func testNotifier() {
        let notifier = Notifier<Int>()
        
        var received: Int?
        
        self.pool += notifier.chain().do { received = $0 }.end()
        
        XCTAssertNil(received)
        
        notifier.notify(value: 3)
        
        XCTAssertEqual(received, 3)
    }
}
