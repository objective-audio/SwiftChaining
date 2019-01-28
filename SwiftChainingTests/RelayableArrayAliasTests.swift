//
//  RelayableArrayAliasTests.swift
//

import XCTest
import Chaining

class RelayableArrayAliasTests: XCTestCase {
    override func setUp() {
    }

    override func tearDown() {
    }

    func testChain() {
        let holder = RelayableArrayHolder([ValueHolder(1), ValueHolder(2), ValueHolder(3)])
        let alias = Alias(holder)
        
        var received: [RelayableArrayHolder<ValueHolder<Int>>.Event] = []
        
        let observer = alias.chain().do({ event in
            received.append(event)
        }).sync()
        
        XCTAssertEqual(received.count, 1)
        
        if case .fetched(let elements) = received[0] {
            XCTAssertEqual(elements, [ValueHolder(1), ValueHolder(2), ValueHolder(3)])
        } else {
            XCTAssertTrue(false)
        }
        
        holder.append(ValueHolder(4))
        
        XCTAssertEqual(received.count, 2)
        
        if case .inserted(let index, let element) = received[1] {
            XCTAssertEqual(index, 3)
            XCTAssertEqual(element, ValueHolder(4))
        } else {
            XCTAssertTrue(false)
        }
        
        observer.invalidate()
    }
    
    func testRawArray() {
        let holder = RelayableArrayHolder([ValueHolder(1), ValueHolder(2), ValueHolder(3)])
        let alias = Alias(holder)
        
        XCTAssertEqual(alias.raw, [ValueHolder(1), ValueHolder(2), ValueHolder(3)])
        
        holder.append(ValueHolder(4))
        
        XCTAssertEqual(alias.raw, [ValueHolder(1), ValueHolder(2), ValueHolder(3), ValueHolder(4)])
    }
    
    func testProperties() {
        let holder = RelayableArrayHolder([ValueHolder(1), ValueHolder(2), ValueHolder(3)])
        let alias = Alias(holder)
        
        XCTAssertEqual(alias.count, 3)
        
        XCTAssertEqual(alias.element(at: 0), ValueHolder(1))
        XCTAssertEqual(alias.element(at: 1), ValueHolder(2))
        XCTAssertEqual(alias.element(at: 2), ValueHolder(3))
        
        XCTAssertEqual(alias.raw.capacity, alias.capacity)
        
        XCTAssertEqual(alias.first, ValueHolder(1))
        XCTAssertEqual(alias.last, ValueHolder(3))
    }
}
