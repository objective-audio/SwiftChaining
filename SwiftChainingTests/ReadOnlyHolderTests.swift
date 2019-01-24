//
//  ReadOnlyHolderTests.swift
//

import XCTest
import Chaining

class ReadOnlyHolderTests: XCTestCase {
    var holder: Holder<Int>!
    var readOnlyHolder: ReadOnlyHolder<Int>!
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
    
    func testReadOnlyHolder() {
        self.holder = Holder(1)
        self.readOnlyHolder = ReadOnlyHolder(holder)
        
        var received: Int?
        
        self.pool += self.readOnlyHolder.chain().do({ value in
            received = value
        }).sync()
        
        XCTAssertEqual(received, 1)
        
        self.holder.value = 2
        
        XCTAssertEqual(received, 2)
    }
    
    func testRawValue() {
        self.holder = Holder(1)
        self.readOnlyHolder = ReadOnlyHolder(holder)
        
        XCTAssertEqual(self.readOnlyHolder.value, 1)
        
        self.holder.value = 2
        
        XCTAssertEqual(self.readOnlyHolder.value, 2)
    }
}
