//
//  DictionaryAliasTests.swift
//

import XCTest
import Chaining

class DictionaryAliasTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testChain() {
        let holder = DictionaryHolder(["1": 1, "2": 2])
        let alias = Alias(holder)
        
        var received: [DictionaryHolder<String, Int>.Event] = []
        
        let observer = alias.chain().do({ event in
            received.append(event)
        }).sync()
        
        XCTAssertEqual(received.count, 1)
        
        if case .fetched(let dictionary) = received[0] {
            XCTAssertEqual(dictionary, ["1": 1, "2": 2])
        } else {
            XCTAssertTrue(false)
        }
        
        holder["3"] = 3
        
        XCTAssertEqual(received.count, 2)
        
        if case .inserted(let key, let value) = received[1] {
            XCTAssertEqual(key, "3")
            XCTAssertEqual(value, 3)
        } else {
            XCTAssertTrue(false)
        }
        
        observer.invalidate()
    }
    
    func testRawDictionary() {
        let holder = DictionaryHolder(["1": 1, "2": 2])
        let alias = Alias(holder)
        
        XCTAssertEqual(alias.rawDictionary, ["1": 1, "2": 2])
        
        holder["3"] = 3
        
        XCTAssertEqual(alias.rawDictionary, ["1": 1, "2": 2, "3": 3])
    }
    
    func testProperties() {
        let holder = DictionaryHolder(["1": 1, "2": 2])
        let alias = Alias(holder)
        
        XCTAssertEqual(alias.count, 2)
        
        XCTAssertEqual(alias.capacity, alias.rawDictionary.capacity)
    }
}
