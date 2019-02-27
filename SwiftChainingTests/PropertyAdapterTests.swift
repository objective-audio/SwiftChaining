//
//  PropertyAdapterTests.swift
//

import XCTest
import Chaining

fileprivate class TestClass {
    var value: Int = 0
}

class PropertyAdapterTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
    
    func testValue() {
        let testObj = TestClass()
        let adapter = PropertyAdapter(testObj, keyPath: \TestClass.value)
        
        XCTAssertEqual(adapter.value, 0)
        
        adapter.value = 1
        
        XCTAssertEqual(adapter.value, 1)
        XCTAssertEqual(testObj.value, 1)
    }
    
    func testSafeValue() {
        var testObj: TestClass? = TestClass()
        
        let adapter = PropertyAdapter(testObj!, keyPath: \TestClass.value)
        
        XCTAssertNotNil(adapter.safeValue)
        XCTAssertEqual(adapter.safeValue, 0)
        
        testObj = nil
        
        XCTAssertNil(adapter.safeValue)
    }

    func testChain() {
        let testObj = TestClass()
        let adapter = PropertyAdapter(testObj, keyPath: \TestClass.value)
        
        var received: [Int] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 0)
        
        adapter.value = 1
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], 1)
        
        observer.invalidate()
    }
    
    func testRecursive() {
        let testObj = TestClass()
        let adapter = PropertyAdapter(testObj, keyPath: \TestClass.value)
        
        var received: [Int] = []
        
        let observer = adapter.chain().do { received.append($0) }.sendTo(adapter).end()
        
        adapter.value = 1
        
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
}
