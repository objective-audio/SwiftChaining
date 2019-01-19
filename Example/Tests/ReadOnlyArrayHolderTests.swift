//
//  ReadOnlyArrayHolderTests.swift
//

import XCTest
import Chaining

class ReadOnlyArrayHolderTests: XCTestCase {
    var holder: ArrayHolder<Int>!
    var readOnlyHolder: ReadOnlyArrayHolder<Int>!
    var pool = ObserverPool()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        self.holder = nil
        self.readOnlyHolder = nil
        self.pool.invalidate()
        
        super.tearDown()
    }
    
    func testReadOnlyArrayHolder() {
        self.holder = ArrayHolder([1, 2, 3])
        self.readOnlyHolder = self.holder
        
        var received: [ArrayHolder<Int>.Event] = []
        
        self.pool += self.readOnlyHolder.chain().do({ event in
            received.append(event)
        }).sync()
        
        XCTAssertEqual(received.count, 1)
        
        if case .fetched(let elements) = received[0] {
            XCTAssertEqual(elements, [1, 2, 3])
        } else {
            XCTAssertTrue(false)
        }
        
        self.holder.append(4)
        
        XCTAssertEqual(received.count, 2)
        
        if case .inserted(let index, let element) = received[1] {
            XCTAssertEqual(index, 3)
            XCTAssertEqual(element, 4)
        } else {
            XCTAssertTrue(false)
        }
    }
    
    func testRawArray() {
        self.holder = ArrayHolder([1, 2, 3])
        self.readOnlyHolder = self.holder
        
        XCTAssertEqual(self.readOnlyHolder.rawArray, [1, 2, 3])
        
        self.holder.append(4)
        
        XCTAssertEqual(self.readOnlyHolder.rawArray, [1, 2, 3, 4])
    }
}
