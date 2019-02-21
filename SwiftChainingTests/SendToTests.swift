//
//  ReceiveTests.swift
//

import XCTest
import Chaining

class SendToTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testSendToWithKeyPath() {
        class TestClass {
            var value: Int = 0
        }
        
        let notifier = Notifier<Int>()
        let testObj = TestClass()
        
        let observer = notifier.chain().sendTo(testObj, keyPath: \TestClass.value).end()
        
        notifier.notify(value: 1)
        
        XCTAssertEqual(testObj.value, 1)
        
        observer.invalidate()
    }
    
    func testSendXTo_tuple2() {
        let notifier0 = ValueHolder(0)
        let notifier1 = ValueHolder("1")
        
        let receiver0 = ValueHolder(2)
        let receiver1 = ValueHolder("3")
        
        let observer = notifier0.chain().combine(notifier1.chain()).send0To(receiver0).send1To(receiver1).sync()
        
        XCTAssertEqual(receiver0.value, 0)
        XCTAssertEqual(receiver1.value, "1")
        
        observer.invalidate()
    }
    
    func testSendXTo_tuple3() {
        let notifier0 = ValueHolder(0)
        let notifier1 = ValueHolder("1")
        let notifier2 = ValueHolder(2.0)
        
        let receiver0 = ValueHolder(3)
        let receiver1 = ValueHolder("4")
        let receiver2 = ValueHolder(5.0)
        
        let observer = notifier0.chain()
            .combine(notifier1.chain())
            .combine(notifier2.chain())
            .map { ($0.0, $0.1, $1) }
            .send0To(receiver0)
            .send1To(receiver1)
            .send2To(receiver2)
            .sync()
        
        XCTAssertEqual(receiver0.value, 0)
        XCTAssertEqual(receiver1.value, "1")
        XCTAssertEqual(receiver2.value, 2.0)
        
        observer.invalidate()
    }
}
