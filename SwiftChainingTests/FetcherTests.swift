//
//  FetcherTests.swift
//

import XCTest
import Chaining

class FetcherTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
    
    func testSync() {
        let fetcher = Fetcher<Int> { 1 }
        
        var received: [Int] = []
        
        let observer = fetcher.chain().do { received.append($0) }.sync()
        
        // syncでフェッチされる
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        observer.invalidate()
    }
    
    func testReceivable() {
        let fetcher = Fetcher<Int> { 1 }
        
        var received: [Int] = []
        
        let observer = fetcher.chain().do { received.append($0) }.end()
        
        XCTAssertEqual(received.count, 0)
        
        fetcher.receive(value: ())
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        observer.invalidate()
    }
    
    func testBroadcast() {
        let fetcher = Fetcher<Int> { 1 }
        
        var received: [Int] = []
        
        let observer = fetcher.chain().do { received.append($0) }.end()
        
        XCTAssertEqual(received.count, 0)
        
        fetcher.broadcast()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        observer.invalidate()
    }
}
