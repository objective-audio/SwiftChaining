//
//  ToTests.swift
//

import XCTest
import Chaining

class ToTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testToValue() {
        let notifier = Notifier<Int>()
        
        var received: String?
        
        let observer = notifier.chain().toValue("text").do { received = $0 }.end()
        
        XCTAssertNil(received)
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(received, "text")
        
        observer.invalidate()
    }
    
    func testToVoid() {
        let notifier = Notifier<Int>()
        
        var received: Bool = false
        
        let observer = notifier.chain().toVoid().do { received = true }.end()
        
        XCTAssertFalse(received)
        
        notifier.notify(value: 1)
        
        XCTAssertTrue(received)
        
        observer.invalidate()
    }
}
