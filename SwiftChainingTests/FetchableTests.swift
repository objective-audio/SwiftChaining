//
//  FetchableTests.swift
//

import XCTest
import Chaining

class FetchableTests: XCTestCase {
    class TestFetcher<T>: Fetchable {
        typealias ChainValue = T
        
        var value: T
        var can: Bool = true
        
        func fetchedValue() -> T {
            return self.value
        }
        
        init(_ initial: T) {
            self.value = initial
        }
        
        func canFetch() -> Bool {
            return self.can
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
        
        let fetcher = TestFetcher(1)
        
        var received: [Int] = []
        
        fetcher.chain()
            .do { received.append($0) }
            .sync().addTo(pool)
        
        XCTAssertEqual(received.count, 1)
        
        fetcher.chain()
            .do { received.append($0) }
            .sync().addTo(pool)
        
        // 同じFetcherから複数chainしても、syncしたchainしか呼ばれない
        XCTAssertEqual(received.count, 2)
    }
    
    func testFetchOptional() {
        let fetcher = TestFetcher<Int?>(nil)
        
        var received: [Int?] = []
        let pool = ObserverPool()
        
        fetcher.chain()
            .do { value in
                received.append(value)
            }
            .sync().addTo(pool)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertNil(received[0])
        
        fetcher.value = 1
        
        fetcher.chain()
            .do { value in
                received.append(value)
            }
            .sync().addTo(pool)
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], 1)
        
        pool.invalidate()
    }
    
    func testCanFetch() {
        let pool = ObserverPool()
        var received: [Int] = []
        
        let fetcher = TestFetcher<Int>(1)
        
        fetcher.can = true
        
        fetcher.chain()
            .do { received.append($0) }
            .sync().addTo(pool)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        fetcher.can = false
        
        fetcher.chain()
            .do { received.append($0) }
            .sync().addTo(pool)
        
        XCTAssertEqual(received.count, 1)
        
        pool.invalidate()
    }
}
