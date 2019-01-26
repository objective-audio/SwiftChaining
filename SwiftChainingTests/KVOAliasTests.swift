//
//  KVOAliasTests.swift
//

import XCTest
import Chaining

fileprivate class TestObject: NSObject {
    @objc dynamic var text: String = "initial"
}

class KVOAliasTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testKVOAlias() {
        let object = TestObject()
        
        let alias = KVOAlias(object, keyPath: \TestObject.text)
        
        var received: [String] = []
        
        let observer = alias.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "initial")
        
        object.text = "test_value"
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], "test_value")
        
        observer.invalidate()
    }
    
    func testInvalidate() {
        let object = TestObject()
        
        let alias = KVOAlias(object, keyPath: \TestObject.text)
        
        var received: [String] = []
        
        let observer = alias.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "initial")
        
        alias.invalidate()
        
        object.text = "test_value"
        
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
    
    func testDeinit() {
        let object = TestObject()
        
        var received: [String] = []
        
        do {
            let alias = KVOAlias(object, keyPath: \TestObject.text)
            
            let observer = alias.chain().do { received.append($0) }.sync()
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0], "initial")
            
            object.text = "test_value_1"
            
            XCTAssertEqual(received.count, 2)
            XCTAssertEqual(received[1], "test_value_1")
            
            observer.invalidate()
        }
        
        object.text = "test_value_2"
        
        XCTAssertEqual(received.count, 2)
    }
}
