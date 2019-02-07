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
        
        let observer = notifier.chain().optional().receive(receiver).end()
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(receiver.value, 1)
        
        observer.invalidate()
    }
}
