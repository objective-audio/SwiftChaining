//
//  RetainReceiverTests.swift
//

import XCTest
import Chaining

class RetainReceiverTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
    
    func testRetainReceiver() {
        let pool = ObserverPool()
        let notifier = Notifier<Int>()
        
        weak var weakReceiver: ValueHolder<Int>?
        
        do {
            let receiver = ValueHolder(0)
            weakReceiver = receiver
            
            notifier.chain()
                .sendTo(receiver.retain())
                .end().addTo(pool)
        }
        
        notifier.notify(value: 1)
        
        XCTAssertNotNil(weakReceiver)
        XCTAssertEqual(weakReceiver?.value, 1)
        
        pool.invalidate()
        
        XCTAssertNil(weakReceiver)
    }
    
    func testNoRetainReceiver() {
        let pool = ObserverPool()
        let notifier = Notifier<Int>()
        
        weak var weakReceiver: ValueHolder<Int>?
        
        do {
            let receiver = ValueHolder(0)
            weakReceiver = receiver
            
            notifier.chain()
                .sendTo(receiver)
                .end().addTo(pool)
        }
        
        XCTAssertNil(weakReceiver)
        
        pool.invalidate()
    }
    
    func testRecursiveRetainHolder() {
        let pool = ObserverPool()
        
        weak var weakHolder: ValueHolder<Int>?
        
        var received: [Int] = []
        
        do {
            let holder = ValueHolder(0)
            weakHolder = holder
            
            holder.retain().chain()
                .sendTo(holder.retain())
                .do { received.append($0) }
                .end().addTo(pool)
        }
        
        XCTAssertNotNil(weakHolder)
        
        weakHolder?.value = 1
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        pool.invalidate()
        
        XCTAssertNil(weakHolder)
    }
}
