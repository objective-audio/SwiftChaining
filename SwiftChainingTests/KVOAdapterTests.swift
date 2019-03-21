//
//  KVOAdapterTests.swift
//

import XCTest
import Chaining

fileprivate class TestObject: NSObject {
    @objc dynamic var text: String = "initial"
}

class KVOAdapterTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSetByOriginal() {
        let object = TestObject()
        
        let adapter = KVOAdapter(object, keyPath: \.text)
        
        var received: [String] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "initial")
        
        object.text = "test_value"
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], "test_value")
        
        observer.invalidate()
    }
    
    func testSetByAdapter() {
        let object = TestObject()
        
        let adapter = KVOAdapter(object, keyPath: \.text)
        
        var received: [String] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "initial")
        
        adapter.value = "test_value"
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], "test_value")
        
        observer.invalidate()
    }
    
    func testSafeValue() {
        var adapter: KVOAdapter<TestObject, String>?
        
        do {
            let object = TestObject()
            
            adapter = KVOAdapter(object, keyPath: \.text)
            
            XCTAssertEqual(adapter?.safeValue, "initial")
        }
        
        XCTAssertNotNil(adapter)
        XCTAssertNil(adapter?.safeValue)
    }
    
    func testInvalidate() {
        let object = TestObject()
        
        let adapter = KVOAdapter(object, keyPath: \.text)
        
        var received: [String] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "initial")
        
        adapter.invalidate()
        
        object.text = "test_value"
        
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
    
    func testDeinit() {
        let object = TestObject()
        
        var received: [String] = []
        
        do {
            let adapter = KVOAdapter(object, keyPath: \.text)
            
            let observer = adapter.chain().do { received.append($0) }.sync()
            
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
    
    func testRecursive() {
        let object = TestObject()
        let adapter = KVOAdapter(object, keyPath: \.text)
        
        var received: [String] = []
        
        let observer = adapter.chain().do { received.append($0) }.sendTo(adapter).end()
        
        adapter.value = "test_value"
        
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
}
