//
//  ImmutableHolderTests.swift
//  SwiftChaining_Tests
//
//  Created by 八十嶋祐樹 on 2018/08/09.
//  Copyright © 2018年 CocoaPods. All rights reserved.
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
        self.immutableHolder = holder.immutable
        
        var received: Int?
        
        self.pool += self.immutableHolder.immutableChain().do({ value in
            received = value
        }).sync()
        
        XCTAssertEqual(received, 1)
        
        self.holder.value = 2
        
        XCTAssertEqual(received, 2)
    }
}
