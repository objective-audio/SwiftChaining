//
//  ObserverTests.swift
//

import XCTest
import Chaining

class ObserverTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInvalidate() {
        // AnyObserverのInvalidateの動作
        
        let mainNotifier = Notifier<Int>()
        let subNotifier = Notifier<Int>()
        
        var received: [Int] = []
        
        let observer = mainNotifier.chain().merge(subNotifier.chain()).do { received.append($0) }.end()
        
        mainNotifier.notify(value: 1)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], 1)
        
        subNotifier.notify(value: 2)
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], 2)
        
        // invalidateされると送信しない
        observer.invalidate()
        
        mainNotifier.notify(value: 3)
        
        XCTAssertEqual(received.count, 2)
        
        subNotifier.notify(value: 4)
        
        XCTAssertEqual(received.count, 2)
    }
    
    func testObserverPool() {
        // ObserverPoolの動作
        
        var pool = ObserverPool()
        let notifier = Notifier<Int>()
        let holder = ValueHolder<String>("0")
        
        var notifierReceived: [Int] = []
        var holderReceived: [String] = []
        
        // +=でObserverPoolにObserverを追加
        pool += notifier.chain().do { notifierReceived.append($0) }.end()
        pool += holder.chain().do { holderReceived.append($0) }.sync()
        
        XCTAssertEqual(holderReceived.count, 1)
        XCTAssertEqual(holderReceived[0], "0")
        
        notifier.notify(value: 1)
        holder.value = "2"
        
        XCTAssertEqual(notifierReceived.count, 1)
        XCTAssertEqual(notifierReceived[0], 1)
        XCTAssertEqual(holderReceived.count, 2)
        XCTAssertEqual(holderReceived[1], "2")
        
        // invalidateを呼ぶと送信しない
        pool.invalidate()
        
        notifier.notify(value: 3)
        holder.value = "4"
        
        XCTAssertEqual(notifierReceived.count, 1)
        XCTAssertEqual(holderReceived.count, 2)
    }
    
    func testObserverPoolRemove() {
        // ObserverPoolから-=で削除する
        
        var pool = ObserverPool()
        let notifier = Notifier<Int>()
        let holder = ValueHolder<String>("0")
        
        var notifierReceived: [Int] = []
        var holderReceived: [String] = []
        
        let notifierObserver = notifier.chain().do { notifierReceived.append($0) }.end()
        let holderObserver = holder.chain().do { holderReceived.append($0) }.sync()
        
        pool += notifierObserver
        pool += holderObserver
        
        XCTAssertEqual(holderReceived.count, 1)
        XCTAssertEqual(holderReceived[0], "0")
        
        notifier.notify(value: 1)
        holder.value = "2"
        
        XCTAssertEqual(notifierReceived.count, 1)
        XCTAssertEqual(notifierReceived[0], 1)
        XCTAssertEqual(holderReceived.count, 2)
        XCTAssertEqual(holderReceived[1], "2")
        
        // -=された方はpoolでinvalidateされなくなる
        pool -= holderObserver
        
        pool.invalidate()
        
        notifier.notify(value: 3)
        holder.value = "4"
        
        XCTAssertEqual(notifierReceived.count, 1)
        XCTAssertEqual(holderReceived.count, 3)
        XCTAssertEqual(holderReceived[2], "4")
    }
}
