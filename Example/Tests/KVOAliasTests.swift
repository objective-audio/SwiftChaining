//
//  KVOAliasTests.swift
//

import XCTest
import SwiftChaining

fileprivate class TestObject: NSObject {
    @objc dynamic var text: String = "initial"
}

class KVOAliasTests: XCTestCase {
    var pool = ObserverPool()
    fileprivate var object: TestObject!
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        self.pool.invalidate()
        self.object = nil
        super.tearDown()
    }

    func testKVOAlias() {
        self.object = TestObject()
        
        let alias = KVOAlias(object: self.object, keyPath: \TestObject.text)
        
        var received: [String] = []
        
        self.pool += alias.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "initial")
        
        self.object.text = "test_value"
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], "test_value")
    }
}
