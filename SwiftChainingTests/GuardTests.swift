//
//  GuardTests.swift
//

import XCTest
import Chaining

class GuardTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGuard() {
        let notifier = Notifier<Int>()
        
        var received: [Int] = []
        
        let observer = notifier.chain().guard { return $0 > 0 }.do { received.append($0) }.end()
        
        notifier.notify(value: 0)
        
        // 0以下なので呼ばれない
        XCTAssertEqual(received.count, 0)
        
        notifier.notify(value: 1)
        
        // 0より大きいので呼ばれる
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        observer.invalidate()
    }
    
    func testGuardIfEqual() {
        let notifier = Notifier<Int>()
        
        var received: [Int] = []
        
        let observer = notifier.chain().guardIfEqual().do { received.append($0) }.end()
        
        notifier.notify(value: 0)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 0)
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], 1)
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(received.count, 2)
        
        observer.invalidate()
    }
}
