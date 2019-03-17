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
            
            notifier.chain().sendTo(receiver.retain()).end().addTo(pool)
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
            
            notifier.chain().sendTo(receiver).end().addTo(pool)
        }
        
        XCTAssertNil(weakReceiver)
        
        pool.invalidate()
    }
}
