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
        
        var received: [String] = []
        
        let observer = notifier.chain().replace("text").do { received.append($0) }.end()
        
        XCTAssertEqual(received.count, 0)
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "text")
        
        observer.invalidate()
    }
    
    func testToVoid() {
        let notifier = Notifier<Int>()
        
        var received: [Void] = []
        
        let observer = notifier.chain().replaceWithVoid().do { received.append($0) }.end()
        
        XCTAssertEqual(received.count, 0)
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
}
