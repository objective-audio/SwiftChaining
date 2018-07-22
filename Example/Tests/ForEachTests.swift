//
//  ForEachTests.swift
//

import XCTest
import SwiftChaining

class ForEachTests: XCTestCase {
    var pool = ObserverPool()
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        self.pool.invalidate()
        super.tearDown()
    }

    func testForEach() {
        let notifier = Notifier<[Int]>()
        
        var received: [(index: Int, value: Int)] = []
        
        self.pool += notifier.chain().forEach().do { received.append($0) }.end()
        
        notifier.notify(value: [2, 4, 6])
        
        // 配列の要素がバラバラに送られる
        XCTAssertEqual(received.count, 3)
        XCTAssertEqual(received[0].index, 0)
        XCTAssertEqual(received[0].value, 2)
        XCTAssertEqual(received[1].index, 1)
        XCTAssertEqual(received[1].value, 4)
        XCTAssertEqual(received[2].index, 2)
        XCTAssertEqual(received[2].value, 6)
    }

}
