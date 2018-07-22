//
//  GuardTests.swift
//

import XCTest
import SwiftChaining

class GuardTests: XCTestCase {
    var pool = ObserverPool()
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        self.pool.invalidate()
        super.tearDown()
    }

    func testGuard() {
        let notifier = Notifier<Int>()
        
        var received: Int?
        
        self.pool += notifier.chain().guard { return $0 > 0 }.do { received = $0 }.end()
        
        notifier.notify(value: 0)
        
        // 0以下なので呼ばれない
        XCTAssertNil(received)
        
        notifier.notify(value: 1)
        
        // 0より大きいので呼ばれる
        XCTAssertEqual(received, 1)
    }
}
