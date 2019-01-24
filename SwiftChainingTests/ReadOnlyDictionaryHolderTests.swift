//
//  ReadOnlyDictionaryHolderTests.swift
//

import XCTest
import Chaining

class ReadOnlyDictionaryHolderTests: XCTestCase {
    var holder: DictionaryHolder<String, Int>!
    var readOnlyHolder: ReadOnlyDictionaryHolder<String, Int>!
    var pool = ObserverPool()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        self.holder = nil
        self.readOnlyHolder = nil
        self.pool.invalidate()
        
        super.tearDown()
    }
    
    func testReadOnlyDictionaryHolder() {
        self.holder = DictionaryHolder(["1": 1, "2": 2])
        self.readOnlyHolder = ReadOnlyDictionaryHolder(self.holder)
        
        var received: [DictionaryHolder<String, Int>.Event] = []
        
        self.pool += self.readOnlyHolder.chain().do({ event in
            received.append(event)
        }).sync()
        
        XCTAssertEqual(received.count, 1)
        
        if case .fetched(let dictionary) = received[0] {
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
    
    func testRawDictionary() {
        self.holder = DictionaryHolder(["1": 1, "2": 2])
        self.readOnlyHolder = ReadOnlyDictionaryHolder(self.holder)
        
        XCTAssertEqual(self.readOnlyHolder.rawDictionary, ["1": 1, "2": 2])
        
        self.holder["3"] = 3
        
        XCTAssertEqual(self.readOnlyHolder.rawDictionary, ["1": 1, "2": 2, "3": 3])
    }
}
