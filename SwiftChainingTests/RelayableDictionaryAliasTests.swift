//
//  RelayableDictionaryAliasTests.swift
//

import XCTest
import Chaining

class RelayableDictionaryAliasTests: XCTestCase {
    override func setUp() {
    }

    override func tearDown() {
    }
    
    func testChain() {
        let holder = RelayableDictionaryHolder(["1": Holder(1), "2": Holder(2)])
        let alias = Alias(holder)
        
        var received: [RelayableDictionaryHolder<String, Holder<Int>>.Event] = []
        
        let observer = alias.chain().do({ event in
            received.append(event)
        }).sync()
        
        XCTAssertEqual(received.count, 1)
        
        if case .fetched(let dictionary) = received[0] {
            XCTAssertEqual(dictionary, ["1": Holder(1), "2": Holder(2)])
        } else {
            XCTAssertTrue(false)
        }
        
        holder["3"] = Holder(3)
        
        XCTAssertEqual(received.count, 2)
        
        if case .inserted(let key, let value) = received[1] {
            XCTAssertEqual(key, "3")
            XCTAssertEqual(value, Holder(3))
        } else {
            XCTAssertTrue(false)
        }
        
        observer.invalidate()
    }
    
    func testRawDictionary() {
        let holder = RelayableDictionaryHolder(["1": Holder(1), "2": Holder(2)])
        let alias = Alias(holder)
        
        XCTAssertEqual(alias.rawDictionary, ["1": Holder(1), "2": Holder(2)])
        
        holder["3"] = Holder(3)
        
        XCTAssertEqual(alias.rawDictionary, ["1": Holder(1), "2": Holder(2), "3": Holder(3)])
    }
    
    func testProperties() {
        let holder = RelayableDictionaryHolder(["1": Holder(1), "2": Holder(2)])
        let alias = Alias(holder)
        
        XCTAssertEqual(alias.count, 2)
        
        XCTAssertEqual(alias.capacity, alias.rawDictionary.capacity)
    }
}
