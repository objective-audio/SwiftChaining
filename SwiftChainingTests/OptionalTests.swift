//
//  OptionalTests.swift
//  SwiftChaining_ios_tests
//
//  Created by yasoshima on 2019/02/07.
//

import XCTest
import Chaining

class OptionalTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testOptional() {
        let notifier = Notifier<Int>()
        let receiver = ValueHolder<Int?>(0)
        
        let observer = notifier.chain().optional().sendTo(receiver).end()
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(receiver.value, 1)
        
        observer.invalidate()
    }
    
    func testGuardUnwrap() {
        let notifier = Notifier<Int?>()
        
        var received: [Int] = []
        
        let observer = notifier.chain().guardUnwrap().do { received.append($0) }.end()
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        XCTAssertNoThrow(notifier.notify(value: nil))
        
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
    
    func testForceUnwrap() {
        let notifier = Notifier<Int?>()
        
        var received: [Int] = []
        
        let observer = notifier.chain().forceUnwrap().do { received.append($0) }.end()
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        // fatal error
        // notifier.notify(value: nil)
        
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
}
