//
//  MapTests.swift
//

import XCTest
import Chaining

class MapTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testIntToString() {
        let sender = ValueHolder<Int>(0)
        let receiver = ValueHolder<String>("")
        
        let observer = sender.chain().map { "\($0)" }.sendTo(receiver).sync()
        
        XCTAssertEqual(receiver.value, "0")
        
        observer.invalidate()
    }
}
