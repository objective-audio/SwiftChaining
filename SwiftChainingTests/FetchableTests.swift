//
//  FetchableTests.swift
//

import XCTest
import Chaining

class FetchableTests: XCTestCase {
    class TestFetcher: Fetchable {
        typealias SendValue = Int
        
        var value: Int = 0
        
        func fetchedValue() -> Int {
            return value
        }
    }
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFetchOnlyJustSynced() {
        let pool = ObserverPool()
        
        let fetcher = Fetcher<Int> { 1 }
        
        var received: [Int] = []
        
        fetcher.chain().do { received.append($0) }.sync().addTo(pool)
        
        XCTAssertEqual(received.count, 1)
        
        fetcher.chain().do { received.append($0) }.sync().addTo(pool)
        
        // 同じFetcherから複数chainしても、syncしたchainしか呼ばれない
        XCTAssertEqual(received.count, 2)
    }
    
    func testFetchOptional() {
        var optValue: Int? = nil
        
        let fetcher = Fetcher<Int?> { optValue }
        
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
    
    func testCanFetch() {
        var optValue: Int? = nil
        
        let fetcher = Fetcher<Int>({ optValue! }, canFetch: { return optValue != nil })
        
        var received: [Int] = []
        
        let observer1 = fetcher.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 0)
        
        observer1.invalidate()
        
        optValue = 1
        
        let observer2 = fetcher.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        observer2.invalidate()
    }
}
