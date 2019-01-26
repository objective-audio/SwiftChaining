//
//  ReadOnlyRelayableArrayHolderTests.swift
//

import XCTest
import Chaining

class ReadOnlyRelayableArrayHolderTests: XCTestCase {
    override func setUp() {
    }

    override func tearDown() {
    }

    func testChain() {
        let holder = RelayableArrayHolder([Holder(1), Holder(2), Holder(3)])
        let readOnlyHolder = ReadOnlyRelayableArrayHolder(holder)
        
        var received: [RelayableArrayHolder<Holder<Int>>.Event] = []
        
        let observer = readOnlyHolder.chain().do({ event in
            received.append(event)
        }).sync()
        
        XCTAssertEqual(received.count, 1)
        
        if case .fetched(let elements) = received[0] {
            XCTAssertEqual(elements, [Holder(1), Holder(2), Holder(3)])
        } else {
            XCTAssertTrue(false)
        }
        
        holder.append(Holder(4))
        
        XCTAssertEqual(received.count, 2)
        
        if case .inserted(let index, let element) = received[1] {
            XCTAssertEqual(index, 3)
            XCTAssertEqual(element, Holder(4))
        } else {
            XCTAssertTrue(false)
        }
        
        observer.invalidate()
    }
    
    func testRawArray() {
        let holder = RelayableArrayHolder([Holder(1), Holder(2), Holder(3)])
        let readOnlyHolder = ReadOnlyRelayableArrayHolder(holder)
        
        XCTAssertEqual(readOnlyHolder.rawArray, [Holder(1), Holder(2), Holder(3)])
        
        holder.append(Holder(4))
        
        XCTAssertEqual(readOnlyHolder.rawArray, [Holder(1), Holder(2), Holder(3), Holder(4)])
    }
    
    func testProperties() {
        let holder = RelayableArrayHolder([Holder(1), Holder(2), Holder(3)])
        let readOnlyHolder = ReadOnlyRelayableArrayHolder(holder)
        
        XCTAssertEqual(readOnlyHolder.count, 3)
        
        XCTAssertEqual(readOnlyHolder.element(at: 0), Holder(1))
        XCTAssertEqual(readOnlyHolder.element(at: 1), Holder(2))
        XCTAssertEqual(readOnlyHolder.element(at: 2), Holder(3))
        
        XCTAssertEqual(readOnlyHolder.rawArray.capacity, readOnlyHolder.capacity)
        
        XCTAssertEqual(readOnlyHolder.first, Holder(1))
        XCTAssertEqual(readOnlyHolder.last, Holder(3))
    }
}
