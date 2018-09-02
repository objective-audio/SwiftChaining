//
//  ImmutableArrayHolderTests.swift
//

import XCTest
import Chaining

class ImmutableArrayHolderTests: XCTestCase {
    var holder: ArrayHolder<Int>!
    var immutableHolder: ImmutableArrayHolder<Int>!
    var pool = ObserverPool()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        self.holder = nil
        self.immutableHolder = nil
        self.pool.invalidate()
        
        super.tearDown()
    }
    
    func testImmutableArrayHolder() {
        self.holder = ArrayHolder([1, 2, 3])
        self.immutableHolder = self.holder
        
        var received: [ArrayHolder<Int>.Event] = []
        
        self.pool += self.immutableHolder.chain().do({ event in
            received.append(event)
        }).sync()
        
        XCTAssertEqual(received.count, 1)
        
        if case .all(let elements) = received[0] {
            XCTAssertEqual(elements, [1, 2, 3])
        } else {
            XCTAssertTrue(false)
        }
        
        self.holder.append(4)
        
        XCTAssertEqual(received.count, 2)
        
        if case .inserted(let index, let elements) = received[1] {
            XCTAssertEqual(index, 3)
            XCTAssertEqual(elements[0], 4)
        } else {
            XCTAssertTrue(false)
        }
    }
    
    func testRawArray() {
        self.holder = ArrayHolder([1, 2, 3])
        self.immutableHolder = self.holder
        
        XCTAssertEqual(self.immutableHolder.rawArray, [1, 2, 3])
        
        self.holder.append(4)
        
        XCTAssertEqual(self.immutableHolder.rawArray, [1, 2, 3, 4])
    }
}
