//
//  SuspenderTests.swift
//

import XCTest
import Chaining

class SuspenderTests: XCTestCase {
    override func setUp() {
    }

    override func tearDown() {
    }

    func testSuspend() {
        let holder = Holder(0)
        
        var received: [Int] = []
        
        let suspender = Suspender {
            return holder.chain().do { value in received.append(value) }.sync()
        }
        
        XCTAssertEqual(received.count, 0)
        
        holder.value = 1
        
        XCTAssertEqual(received.count, 0)
        
        suspender.resume()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        holder.value = 2
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], 2)
        
        suspender.suspend()
        
        holder.value = 3
        
        XCTAssertEqual(received.count, 2)
        
        suspender.resume()
        
        XCTAssertEqual(received.count, 3)
        XCTAssertEqual(received[2], 3)
        
        suspender.invalidate()
        
        holder.value = 4
        
        XCTAssertEqual(received.count, 3)
        
        suspender.resume()
        
        XCTAssertEqual(received.count, 3)
    }
}
