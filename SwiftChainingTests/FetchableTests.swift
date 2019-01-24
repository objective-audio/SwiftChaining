//
//  FetchableTests.swift
//

import XCTest
import Chaining

class FetchableTests: XCTestCase {
    var pool = ObserverPool()
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        self.pool.invalidate()
        super.tearDown()
    }

    func testFetcher() {
        let fetcher = Fetcher<Int>() { return 1 }
        
        var received: Int?
        
        self.pool += fetcher.chain().do { received = $0 }.sync()
        
        // syncでフェッチされる
        XCTAssertEqual(received, 1)
    }
    
    func testFetcherReceivable() {
        let fetcher = Fetcher<Int>() { return 1 }
        
        var received: Int?
        
        self.pool += fetcher.chain().do { received = $0 }.end()
        
        XCTAssertNil(received)
        
        // receiveした値がそのまま送信される
        fetcher.receive(value: 2)
        
        XCTAssertEqual(received, 2)
    }
    
    func testFetcherBroadcastWithVoid() {
        let fetcher = Fetcher<Int>() { return 1 }
        
        var received: Int?
        
        self.pool += fetcher.chain().do { received = $0 }.end()
        
        XCTAssertNil(received)
        
        fetcher.broadcast()
        
        XCTAssertEqual(received, 1)
    }
    
    func testFetchOnlyJustSynced() {
        var pool = ObserverPool()
        
        let fetcher = Fetcher<Int>() { return 1 }
        
        var received: [Int] = []
        
        pool += fetcher.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        
        pool += fetcher.chain().do { received.append($0) }.sync()
        
        // 同じFetcherから複数chainしても、syncしたchainしか呼ばれない
        XCTAssertEqual(received.count, 2)
    }
    
    func testFetchOptional() {
        var optValue: Int? = 1
        
        let fetcher = Fetcher<Int>() {
            return optValue
        }
        
        var called: Bool = false
        var received: Int?
        
        self.pool += fetcher.chain().do({ value in
            called = true
            received = value
        }).sync()
        
        XCTAssertTrue(called)
        XCTAssertEqual(received, 1)
        
        optValue = nil
        
        fetcher.broadcast()
        
        called = false
        received = nil
        
        XCTAssertFalse(called)
        XCTAssertNil(received)
    }
}
