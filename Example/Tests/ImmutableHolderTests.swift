//
//  ImmutableHolderTests.swift
//

import XCTest
import Chaining

class ImmutableHolderTests: XCTestCase {
    var holder: Holder<Int>!
    var immutableHolder: ImmutableHolder<Int>!
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
    
    func testImmutableHolder() {
        self.holder = Holder(1)
        self.immutableHolder = holder
        
        var received: Int?
        
        self.pool += self.immutableHolder.chain().do({ value in
            received = value
        }).sync()
        
        XCTAssertEqual(received, 1)
        
        self.holder.value = 2
        
        XCTAssertEqual(received, 2)
    }
}
