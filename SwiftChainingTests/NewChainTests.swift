//
//  NewChainTests.swift
//

import XCTest
import Chaining

class NewChainTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCoreChain() {
        let notifier = Notifier<Int>()
        
        var received: [Int] = []
        
        let observer = notifier.chain().do { received.append($0) }.end()
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        observer.invalidate()
    }
    
    func testEach() {
        let notifier = Notifier<[Int]>()
        
        var received: [Int] = []
        
        let observer = notifier.chain().each().do { received.append($0) }.end()
        
        notifier.notify(value: [0, 1, 2])
        
        XCTAssertEqual(received.count, 3)
        XCTAssertEqual(received, [0, 1, 2])
        
        observer.invalidate()
    }
}
