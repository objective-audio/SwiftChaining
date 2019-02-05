//
//  FetchableTests.swift
//

import XCTest
import Chaining

class FetchableTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFetcher() {
        let fetcher = Fetcher<Int>() { return 1 }
        
        var received: Int?
        
        let observer = fetcher.chain().do { received = $0 }.sync()
        
        // syncでフェッチされる
        XCTAssertEqual(received, 1)
        
        observer.invalidate()
    }
    
    func testFetcherReceivable() {
        let fetcher = Fetcher<Int>() { return 1 }
        
        var received: Int?
        
        let observer = fetcher.chain().do { received = $0 }.end()
        
        XCTAssertNil(received)
        
        // receiveした値がそのまま送信される
        fetcher.receive(value: 2)
        
        XCTAssertEqual(received, 2)
        
        observer.invalidate()
    }
    
    func testFetcherBroadcastWithVoid() {
        let fetcher = Fetcher<Int>() { return 1 }
        
        var received: Int?
        
        let observer = fetcher.chain().do { received = $0 }.end()
        
        XCTAssertNil(received)
        
        fetcher.broadcast()
        
        XCTAssertEqual(received, 1)
        
        observer.invalidate()
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
        var optValue: Int? = nil
        
        let fetcher = Fetcher<Int?>() {
            return optValue
        }
        
        var received: [Int?] = []
        
        let observer = fetcher.chain().do({ value in
            received.append(value)
        }).sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertNil(received[0])
        
        optValue = 1
        
        fetcher.broadcast()
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], 1)
        
        observer.invalidate()
    }
}
