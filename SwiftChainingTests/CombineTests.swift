//
//  CombineTests.swift
//

import XCTest
import Chaining

class CombineTests: XCTestCase {
    var pool = ObserverPool()
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        self.pool.invalidate()
        super.tearDown()
    }

    func testCombineEachFetchable() {
        // メインとサブが両方Fetchableの場合
        
        let main = Holder<Int>(1)
        let sub = Holder<String>("2")
        
        var received: (Int, String)?
        
        self.pool += main.chain().combine(sub.chain()).do { received = $0 }.sync()
        
        // syncだけで両方送られてdoが呼ばれる
        XCTAssertEqual(received?.0, 1)
        XCTAssertEqual(received?.1, "2")
    }
    
    func testCombineMainFetchable() {
        // メインのみFetchableの場合
        
        let main = Holder<Int>(1)
        let sub = Notifier<String>()
        
        var received: (Int, String)?
        
        self.pool += main.chain().combine(sub.chain()).do { received = $0 }.sync()
        
        // syncではメインからのみ送信
        XCTAssertNil(received)
        
        sub.notify(value: "2")
        
        // サブからも送られてdoが呼ばれる
        XCTAssertEqual(received?.0, 1)
        XCTAssertEqual(received?.1, "2")
    }
    
    func testCombineSubFetchable() {
        // サブのみFetchableの場合
        
        let main = Notifier<Int>()
        let sub = Holder<String>("1")
        
        var received: (Int, String)?
        
        self.pool += main.chain().combine(sub.chain()).do { received = $0 }.sync()
        
        // syncではサブからのみ送信
        XCTAssertNil(received)
        
        main.notify(value: 2)
        
        // メインからも送られてdoが呼ばれる
        XCTAssertEqual(received?.0, 2)
        XCTAssertEqual(received?.1, "1")
    }
    
    func testCombineNoFetchable() {
        // 両方Fetchableでない場合
        
        let main = Notifier<Int>()
        let sub = Notifier<String>()
        
        var received: (Int, String)?
        
        self.pool += main.chain().combine(sub.chain()).do { received = $0 }.end()
        
        // まだどちらからも送信されていない
        XCTAssertNil(received)
        
        main.notify(value: 1)
        
        // メインからのみ送信されているので止まっている
        XCTAssertNil(received)
        
        sub.notify(value: "2")
        
        // サブからも送信されたのでdoが呼ばれる
        XCTAssertEqual(received?.0, 1)
        XCTAssertEqual(received?.1, "2")
    }

}
