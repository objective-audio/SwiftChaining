//
//  ImmutableDictionaryHolderTests.swift
//

import XCTest
import Chaining

class ImmutableDictionaryHolderTests: XCTestCase {
    var holder: DictionaryHolder<String, Int>!
    var immutableHolder: ImmutableDictionaryHolder<String, Int>!
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
    
    func testImmutableDictionaryHolder() {
        self.holder = DictionaryHolder(["1": 1, "2": 2])
        self.immutableHolder = self.holder
        
        var received: [DictionaryHolder<String, Int>.Event] = []
        
        self.pool += self.immutableHolder.chain().do({ event in
            received.append(event)
        }).sync()
        
        XCTAssertEqual(received.count, 1)
        
        if case .all(let dictionary) = received[0] {
            XCTAssertEqual(dictionary, ["1": 1, "2": 2])
        } else {
            XCTAssertTrue(false)
        }
        
        self.holder["3"] = 3
        
        XCTAssertEqual(received.count, 2)
        
        if case .inserted(let key, let value) = received[1] {
            XCTAssertEqual(key, "3")
            XCTAssertEqual(value, 3)
        } else {
            XCTAssertTrue(false)
        }
    }
}
