//
//  ReadOnlyHolderTests.swift
//

import XCTest
import Chaining

class ReadOnlyHolderTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testChain() {
        let holder = Holder(1)
        let readOnlyHolder = ReadOnlyHolder(holder)
        
        var received: Int?
        
        let observer = readOnlyHolder.chain().do({ value in
            received = value
        }).sync()
        
        XCTAssertEqual(received, 1)
        
        holder.value = 2
        
        XCTAssertEqual(received, 2)
        
        observer.invalidate()
    }
    
    func testRawValue() {
        let holder = Holder(1)
        let readOnlyHolder = ReadOnlyHolder(holder)
        
        XCTAssertEqual(readOnlyHolder.value, 1)
        
        holder.value = 2
        
        XCTAssertEqual(readOnlyHolder.value, 2)
    }
}
