//
//  PropertyAdapterCommonTests.swift
//

import XCTest
import Chaining

fileprivate class TestClass {
    var value1: Int = 0
    var value2: Int = 0
}

class PropertyAdapterCommonTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testManyAdapter() {
        let testObj = TestClass()
        
        let adapter1a = PropertyAdapter.common(testObj, keyPath: \TestClass.value1)
        let adapter1b = PropertyAdapter.common(testObj, keyPath: \TestClass.value1)
        let adapter2 = PropertyAdapter.common(testObj, keyPath: \TestClass.value2)
        
        XCTAssertEqual(ObjectIdentifier(adapter1a), ObjectIdentifier(adapter1b))
        XCTAssertNotEqual(ObjectIdentifier(adapter1a), ObjectIdentifier(adapter2))
        
        var received1a: [Int] = []
        var received1b: [Int] = []
        var received2: [Int] = []
        
        let observer1a = adapter1a.chain().do { received1a.append($0) }.end()
        let observer1b = adapter1a.chain().do { received1b.append($0) }.end()
        let observer2 = adapter1a.chain().do { received2.append($0) }.end()
        
        adapter1a.value = 1
        
        XCTAssertEqual(received1a.count, 1)
        XCTAssertEqual(received1a[0], 1)
        XCTAssertEqual(received1b.count, 1)
        XCTAssertEqual(received1b[0], 1)
        XCTAssertEqual(received2.count, 1)
        
        observer1a.invalidate()
        observer1b.invalidate()
        observer2.invalidate()
    }
    
    func testTargetRemoved() {
        var testObj: TestClass? = TestClass()
        
        let adapter = PropertyAdapter.common(testObj!, keyPath: \TestClass.value1)
        
        var received: [Int] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        
        testObj = nil
        
        adapter.value = 1
        
        XCTAssertEqual(received.count, 1)
 
        observer.invalidate()
    }
}
