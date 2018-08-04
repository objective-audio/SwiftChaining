//
//  KVOAliasTests.swift
//

import XCTest
import Chaining

fileprivate class TestObject: NSObject {
    @objc dynamic var text: String = "initial"
}

class KVOAliasTests: XCTestCase {
    var pool = ObserverPool()
    private var object: TestObject!
    private var alias: KVOAlias<TestObject, String>!
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        self.pool.invalidate()
        self.object = nil
        self.alias = nil
        super.tearDown()
    }

    func testKVOAlias() {
        self.object = TestObject()
        
        self.alias = KVOAlias(object: self.object, keyPath: \TestObject.text)
        
        var received: [String] = []
        
        self.pool += alias.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "initial")
        
        self.object.text = "test_value"
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], "test_value")
    }
    
    func testInvalidate() {
        self.object = TestObject()
        
        let alias = KVOAlias(object: self.object, keyPath: \TestObject.text)
        
        var received: [String] = []
        
        self.pool += alias.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "initial")
        
        alias.invalidate()
        
        self.object.text = "test_value"
        
        XCTAssertEqual(received.count, 1)
    }
}
