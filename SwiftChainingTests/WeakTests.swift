//
//  WeakTests.swift
//

import XCTest
@testable import Chaining

class WeakTests: XCTestCase {
    class TestClass {
    }
    
    override func setUp() {
    }

    override func tearDown() {
    }

    func testHashable() {
        let obj = TestClass()
        
        let weakObjA = Weak(obj)
        let weakObjB = Weak(obj)
        
        XCTAssertEqual(weakObjA.hashValue, ObjectIdentifier(obj).hashValue)
        XCTAssertEqual(weakObjA.hashValue, weakObjB.hashValue)
    }
    
    func testEquatable() {
        let obj1 = TestClass()
        let obj2 = TestClass()
        
        let weakObj1a = Weak(obj1)
        let weakObj1b = Weak(obj1)
        let weakObj2 = Weak(obj2)
        
        XCTAssertEqual(weakObj1a, weakObj1b)
        XCTAssertNotEqual(weakObj1a, weakObj2)
    }
}
