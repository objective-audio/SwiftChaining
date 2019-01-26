//
//  ReadOnlyArrayHolderTests.swift
//

import XCTest
import Chaining

class ReadOnlyArrayHolderTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testChain() {
        let holder = ArrayHolder([1, 2, 3])
        let readOnlyHolder = ReadOnlyArrayHolder(holder)
        
        var received: [ArrayHolder<Int>.Event] = []
        
        let observer = readOnlyHolder.chain().do({ event in
            received.append(event)
        }).sync()
        
        XCTAssertEqual(received.count, 1)
        
        if case .fetched(let elements) = received[0] {
            XCTAssertEqual(elements, [1, 2, 3])
        } else {
            XCTAssertTrue(false)
        }
        
        holder.append(4)
        
        XCTAssertEqual(received.count, 2)
        
        if case .inserted(let index, let element) = received[1] {
            XCTAssertEqual(index, 3)
            XCTAssertEqual(element, 4)
        } else {
            XCTAssertTrue(false)
        }
        
        observer.invalidate()
    }
    
    func testRawArray() {
        let holder = ArrayHolder([1, 2, 3])
        let readOnlyHolder = ReadOnlyArrayHolder(holder)
        
        XCTAssertEqual(readOnlyHolder.rawArray, [1, 2, 3])
        
        holder.append(4)
        
        XCTAssertEqual(readOnlyHolder.rawArray, [1, 2, 3, 4])
    }
    
    func testProperties() {
        let holder = ArrayHolder([1, 2, 3])
        let readOnlyHolder = ReadOnlyArrayHolder(holder)
        
        XCTAssertEqual(readOnlyHolder.count, 3)
        
        XCTAssertEqual(readOnlyHolder.element(at: 0), 1)
        XCTAssertEqual(readOnlyHolder.element(at: 1), 2)
        XCTAssertEqual(readOnlyHolder.element(at: 2), 3)
        
        XCTAssertEqual(readOnlyHolder.rawArray.capacity, readOnlyHolder.capacity)
        
        XCTAssertEqual(readOnlyHolder.first, 1)
        XCTAssertEqual(readOnlyHolder.last, 3)
    }
}
