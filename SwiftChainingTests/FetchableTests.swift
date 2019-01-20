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
    
    func testRelayedChainWithFetchableAndSendableValue() {
        // Fetchableの要素がSendableな場合のrelayedChainの動作
        
        typealias RecursiveHolder = Holder<Notifier<Int>>
        typealias RecursiveEvent = RecursiveHolder.RelayingEvent
        
        let notifier = Notifier<Int>()
        let holder = RecursiveHolder(notifier)
        
        var received: [RecursiveEvent] = []
        
        self.pool += holder.relayedChain().do { received.append($0) }.sync()
        
        // syncでcurrentを送信
        XCTAssertEqual(received.count, 1)
        
        if case .current(let value) = received[0] {
            XCTAssertEqual(ObjectIdentifier(value), ObjectIdentifier(notifier))
        } else {
            XCTAssertTrue(false)
        }
        
        // 要素から送るとralayedを送信
        notifier.notify(value: 1)
        
        XCTAssertEqual(received.count, 2)
        
        if case .relayed(let value) = received[1] {
            XCTAssertEqual(value, 1)
        } else {
            XCTAssertTrue(false)
        }
        
        // 要素をセットするとcurrentを送信
        let notifier2 = Notifier<Int>()
        
        holder.value = notifier2
        
        XCTAssertEqual(received.count, 3)
        
        if case .current(let value) = received[2] {
            XCTAssertEqual(ObjectIdentifier(value), ObjectIdentifier(notifier2))
        } else {
            XCTAssertTrue(false)
        }
        
        // 外れた要素から送ろうとしても何もしない
        notifier.notify(value: 2)
        
        XCTAssertEqual(received.count, 3)
    }
    
    func testRelayedChainWithFetchableAndFetchableValue() {
        // Fetchableの要素がFetchableな場合のrelayedChainの動作
        
        typealias RelayingHolder = Holder<Holder<Int>>
        typealias RelayingEvent = RelayingHolder.RelayingEvent
        
        let childHolder1 = Holder<Int>(1)
        let holder = RelayingHolder(childHolder1)
        
        var received: [RelayingEvent] = []
        
        self.pool += holder.relayedChain().do { received.append($0) }.sync()
        
        // syncでcurrentを送信
        XCTAssertEqual(received.count, 1)
        
        if case .current(let value) = received[0] {
            XCTAssertEqual(value.value, 1)
        } else {
            XCTAssertTrue(false)
        }
        
        let childHolder2 = Holder<Int>(2)
        
        holder.value = childHolder2
        
        // 要素がセットされるとcurrentを送信し、続いてrelayedも送信
        XCTAssertEqual(received.count, 3)
        
        if case .current(let value) = received[1] {
            XCTAssertEqual(value.value, 2)
        } else {
            XCTAssertTrue(false)
        }
        
        if case .relayed(let value) = received[2] {
            XCTAssertEqual(value, 2)
        } else {
            XCTAssertTrue(false)
        }
        
        // 要素の要素がセットされるとrelayedを送信
        childHolder2.value = 3
        
        XCTAssertEqual(received.count, 4)
        
        if case .relayed(let value) = received[3] {
            XCTAssertEqual(value, 3)
        } else {
            XCTAssertTrue(false)
        }
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
