//
//  AliasTests.swift
//

import XCTest
import Chaining

class AliasTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testChain() {
        let holder = ValueHolder(1)
        let alias = Alias(holder)
        
        var received: Int?
        
        let observer = alias.chain().do({ value in
            received = value
        }).sync()
        
        XCTAssertEqual(received, 1)
        
        holder.value = 2
        
        XCTAssertEqual(received, 2)
        
        observer.invalidate()
    }
    
    func testRawValue() {
        let holder = ValueHolder(1)
        let alias = Alias(holder)
        
        XCTAssertEqual(alias.value, 1)
        
        holder.value = 2
        
        XCTAssertEqual(alias.value, 2)
    }
}
