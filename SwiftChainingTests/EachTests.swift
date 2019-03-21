//
//  EachTests.swift
//

import XCTest
import Chaining

class EachTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEach() {
        let notifier = Notifier<[Int]>()
        
        var received: [Int] = []
        
        let observer =
            notifier.chain()
                .each()
                .do { received.append($0) }
                .end()
        
        notifier.notify(value: [2, 4, 6])
        
        // 配列の要素がバラバラに送られる
        XCTAssertEqual(received.count, 3)
        XCTAssertEqual(received[0], 2)
        XCTAssertEqual(received[1], 4)
        XCTAssertEqual(received[2], 6)
        
        observer.invalidate()
    }
}
