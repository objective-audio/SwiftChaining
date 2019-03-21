//
//  CombineTests.swift
//

import XCTest
import Chaining

class CombineTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEachFetchable() {
        // メインとサブが両方Fetchableの場合
        
        let main = ValueHolder<Int>(1)
        let sub = ValueHolder<String>("2")
        
        var received: [(Int, String)] = []
        
        let observer =
            main.chain().combine(sub.chain())
                .do { received.append($0) }
                .sync()
        
        // syncだけで両方送られてdoが呼ばれる
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].0, 1)
        XCTAssertEqual(received[0].1, "2")
        
        observer.invalidate()
    }
    
    func testMainFetchable() {
        // メインのみFetchableの場合
        
        let main = ValueHolder<Int>(1)
        let sub = Notifier<String>()
        
        var received: [(Int, String)] = []
        
        let observer =
            main.chain().combine(sub.chain())
                .do { received.append($0) }
                .sync()
        
        // syncではメインからのみ送信
        XCTAssertEqual(received.count, 0)
        
        sub.notify(value: "2")
        
        // サブからも送られてdoが呼ばれる
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].0, 1)
        XCTAssertEqual(received[0].1, "2")
        
        observer.invalidate()
    }
    
    func testSubFetchable() {
        // サブのみFetchableの場合
        
        let main = Notifier<Int>()
        let sub = ValueHolder<String>("1")
        
        var received: [(Int, String)] = []
        
        let observer =
            main.chain().combine(sub.chain())
                .do { received.append($0) }
                .sync()
        
        // syncではサブからのみ送信
        XCTAssertEqual(received.count, 0)
        
        main.notify(value: 2)
        
        // メインからも送られてdoが呼ばれる
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].0, 2)
        XCTAssertEqual(received[0].1, "1")
        
        observer.invalidate()
    }
    
    func testNoFetchable() {
        // 両方Fetchableでない場合
        
        let main = Notifier<Int>()
        let sub = Notifier<String>()
        
        var received: [(Int, String)] = []
        
        let observer =
            main.chain().combine(sub.chain())
                .do { received.append($0) }
                .end()
        
        // まだどちらからも送信されていない
        XCTAssertEqual(received.count, 0)
        
        main.notify(value: 1)
        
        // メインからのみ送信されているので止まっている
        XCTAssertEqual(received.count, 0)
        
        sub.notify(value: "2")
        
        // サブからも送信されたのでdoが呼ばれる
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].0, 1)
        XCTAssertEqual(received[0].1, "2")
        
        observer.invalidate()
    }
    
    func testTuple2() {
        let holder0 = ValueHolder(0)
        let holder1 = ValueHolder(1)
        let holder2 = ValueHolder(2)
        let notifier0 = Notifier<Int>()
        let notifier1 = Notifier<Int>()
        let notifier2 = Notifier<Int>()
        
        do {
            var received: [(Int, Int, Int)] = []
            
            let observer =
                holder0.chain()
                    .combine(holder1.chain())
                    .combine(holder2.chain())
                    .do { received.append($0) }
                    .sync()
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0].0, 0)
            XCTAssertEqual(received[0].1, 1)
            XCTAssertEqual(received[0].2, 2)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int, Int, Int)] = []
            
            let observer =
                holder0.chain()
                    .combine(holder1.chain())
                    .combine(notifier2.chain())
                    .do { received.append($0) }
                    .sync()
            
            XCTAssertEqual(received.count, 0)
            
            notifier2.notify(value: 2)
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0].0, 0)
            XCTAssertEqual(received[0].1, 1)
            XCTAssertEqual(received[0].2, 2)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int, Int, Int)] = []
            
            let observer =
                notifier0.chain()
                    .combine(notifier1.chain())
                    .combine(holder2.chain())
                    .do { received.append($0) }
                    .sync()
            
            notifier0.notify(value: 0)
            
            XCTAssertEqual(received.count, 0)
            
            notifier1.notify(value: 1)
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0].0, 0)
            XCTAssertEqual(received[0].1, 1)
            XCTAssertEqual(received[0].2, 2)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int, Int, Int)] = []
            
            let observer =
                notifier0.chain()
                    .combine(notifier1.chain())
                    .combine(notifier2.chain())
                    .do { received.append($0) }
                    .end()
            
            notifier0.notify(value: 0)
            notifier1.notify(value: 1)
            
            XCTAssertEqual(received.count, 0)
            
            notifier2.notify(value: 2)
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0].0, 0)
            XCTAssertEqual(received[0].1, 1)
            XCTAssertEqual(received[0].2, 2)
            
            observer.invalidate()
        }
    }
    
    func testTuple3() {
        let holder0 = ValueHolder(0)
        let holder1 = ValueHolder(1)
        let holder2 = ValueHolder(2)
        let holder3 = ValueHolder(3)
        let notifier0 = Notifier<Int>()
        let notifier1 = Notifier<Int>()
        let notifier2 = Notifier<Int>()
        let notifier3 = Notifier<Int>()
        
        do {
            var received: [(Int, Int, Int, Int)] = []
            
            let observer = holder0.chain()
                .combine(holder1.chain())
                .combine(holder2.chain())
                .combine(holder3.chain())
                .do { received.append($0) }
                .sync()
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0].0, 0)
            XCTAssertEqual(received[0].1, 1)
            XCTAssertEqual(received[0].2, 2)
            XCTAssertEqual(received[0].3, 3)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int, Int, Int, Int)] = []
            
            let observer = holder0.chain()
                .combine(holder1.chain())
                .combine(holder2.chain())
                .combine(notifier3.chain())
                .do { received.append($0) }
                .sync()
            
            XCTAssertEqual(received.count, 0)
            
            notifier3.notify(value: 3)
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0].0, 0)
            XCTAssertEqual(received[0].1, 1)
            XCTAssertEqual(received[0].2, 2)
            XCTAssertEqual(received[0].3, 3)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int, Int, Int, Int)] = []
            
            let observer = notifier0.chain()
                .combine(notifier1.chain())
                .combine(notifier2.chain())
                .combine(holder3.chain())
                .do { received.append($0) }
                .sync()
            
            notifier0.notify(value: 0)
            notifier1.notify(value: 1)
            
            XCTAssertEqual(received.count, 0)
            
            notifier2.notify(value: 2)
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0].0, 0)
            XCTAssertEqual(received[0].1, 1)
            XCTAssertEqual(received[0].2, 2)
            XCTAssertEqual(received[0].3, 3)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int, Int, Int, Int)] = []
            
            let observer = notifier0.chain()
                .combine(notifier1.chain())
                .combine(notifier2.chain())
                .combine(notifier3.chain())
                .do { received.append($0) }
                .end()
            
            notifier0.notify(value: 0)
            notifier1.notify(value: 1)
            notifier2.notify(value: 2)
            
            XCTAssertEqual(received.count, 0)
            
            notifier3.notify(value: 3)
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0].0, 0)
            XCTAssertEqual(received[0].1, 1)
            XCTAssertEqual(received[0].2, 2)
            XCTAssertEqual(received[0].3, 3)
            
            observer.invalidate()
        }
    }
    
    func testTuple4() {
        let holder0 = ValueHolder(0)
        let holder1 = ValueHolder(1)
        let holder2 = ValueHolder(2)
        let holder3 = ValueHolder(3)
        let holder4 = ValueHolder(4)
        let notifier0 = Notifier<Int>()
        let notifier1 = Notifier<Int>()
        let notifier2 = Notifier<Int>()
        let notifier3 = Notifier<Int>()
        let notifier4 = Notifier<Int>()
        
        do {
            var received: [(Int, Int, Int, Int, Int)] = []
            
            let observer = holder0.chain()
                .combine(holder1.chain())
                .combine(holder2.chain())
                .combine(holder3.chain())
                .combine(holder4.chain())
                .do { received.append($0) }
                .sync()
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0].0, 0)
            XCTAssertEqual(received[0].1, 1)
            XCTAssertEqual(received[0].2, 2)
            XCTAssertEqual(received[0].3, 3)
            XCTAssertEqual(received[0].4, 4)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int, Int, Int, Int, Int)] = []
            
            let observer = holder0.chain()
                .combine(holder1.chain())
                .combine(holder2.chain())
                .combine(holder3.chain())
                .combine(notifier4.chain())
                .do { received.append($0) }
                .sync()
            
            XCTAssertEqual(received.count, 0)
            
            notifier4.notify(value: 4)
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0].0, 0)
            XCTAssertEqual(received[0].1, 1)
            XCTAssertEqual(received[0].2, 2)
            XCTAssertEqual(received[0].3, 3)
            XCTAssertEqual(received[0].4, 4)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int, Int, Int, Int, Int)] = []
            
            let observer = notifier0.chain()
                .combine(notifier1.chain())
                .combine(notifier2.chain())
                .combine(notifier3.chain())
                .combine(holder4.chain())
                .do { received.append($0) }
                .sync()
            
            notifier0.notify(value: 0)
            notifier1.notify(value: 1)
            notifier2.notify(value: 2)
            
            XCTAssertEqual(received.count, 0)
            
            notifier3.notify(value: 3)
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0].0, 0)
            XCTAssertEqual(received[0].1, 1)
            XCTAssertEqual(received[0].2, 2)
            XCTAssertEqual(received[0].3, 3)
            XCTAssertEqual(received[0].4, 4)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int, Int, Int, Int, Int)] = []
            
            let observer = notifier0.chain()
                .combine(notifier1.chain())
                .combine(notifier2.chain())
                .combine(notifier3.chain())
                .combine(notifier4.chain())
                .do { received.append($0) }
                .end()
            
            notifier0.notify(value: 0)
            notifier1.notify(value: 1)
            notifier2.notify(value: 2)
            notifier3.notify(value: 3)
            
            XCTAssertEqual(received.count, 0)
            
            notifier4.notify(value: 4)
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0].0, 0)
            XCTAssertEqual(received[0].1, 1)
            XCTAssertEqual(received[0].2, 2)
            XCTAssertEqual(received[0].3, 3)
            XCTAssertEqual(received[0].4, 4)
            
            observer.invalidate()
        }
    }
}
