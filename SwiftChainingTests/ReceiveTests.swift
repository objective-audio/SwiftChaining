//
//  ReceiveTests.swift
//

import XCTest
import Chaining

class ReceiveTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testReceiveWithKeyPath() {
        class TestClass {
            var value: Int = 0
        }
        
        let notifier = Notifier<Int>()
        let testObj = TestClass()
        
        let observer = notifier.chain().receive(testObj, keyPath: \TestClass.value).end()
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(testObj.value, 1)
        
        observer.invalidate()
    }
}
