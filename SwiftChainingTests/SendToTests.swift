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

    func testSendXTo_tuple2() {
        let sender = ValueHolder((0, "1"))
        
        let receiver0 = ValueHolder(10)
        let receiver1 = ValueHolder("11")
        
        let observer = sender.chain()
            .send0To(receiver0)
            .send1To(receiver1)
            .sync()
        
        XCTAssertEqual(receiver0.value, 0)
        XCTAssertEqual(receiver1.value, "1")
        
        observer.invalidate()
    }
    
    func testSendXTo_tuple3() {
        let sender = ValueHolder((0, "1", 2.0))
        
        let receiver0 = ValueHolder(10)
        let receiver1 = ValueHolder("11")
        let receiver2 = ValueHolder(12.0)
        
        let observer = sender.chain()
            .send0To(receiver0)
            .send1To(receiver1)
            .send2To(receiver2)
            .sync()
        
        XCTAssertEqual(receiver0.value, 0)
        XCTAssertEqual(receiver1.value, "1")
        XCTAssertEqual(receiver2.value, 2.0)
        
        observer.invalidate()
    }
    
    func testSendXTo_tuple4() {
        let sender = ValueHolder((0, "1", 2.0, 3))
        
        let receiver0 = ValueHolder(10)
        let receiver1 = ValueHolder("11")
        let receiver2 = ValueHolder(12.0)
        let receiver3 = ValueHolder(13)
        
        let observer = sender.chain()
            .send0To(receiver0)
            .send1To(receiver1)
            .send2To(receiver2)
            .send3To(receiver3)
            .sync()
        
        XCTAssertEqual(receiver0.value, 0)
        XCTAssertEqual(receiver1.value, "1")
        XCTAssertEqual(receiver2.value, 2.0)
        XCTAssertEqual(receiver3.value, 3)
        
        observer.invalidate()
    }
    
    func testSendXTo_tuple5() {
        let sender = ValueHolder((0, "1", 2.0, 3, "4"))
        
        let receiver0 = ValueHolder(10)
        let receiver1 = ValueHolder("11")
        let receiver2 = ValueHolder(12.0)
        let receiver3 = ValueHolder(13)
        let receiver4 = ValueHolder("14")
        
        let observer = sender.chain()
            .send0To(receiver0)
            .send1To(receiver1)
            .send2To(receiver2)
            .send3To(receiver3)
            .send4To(receiver4)
            .sync()
        
        XCTAssertEqual(receiver0.value, 0)
        XCTAssertEqual(receiver1.value, "1")
        XCTAssertEqual(receiver2.value, 2.0)
        XCTAssertEqual(receiver3.value, 3)
        XCTAssertEqual(receiver4.value, "4")
        
        observer.invalidate()
    }
    
    func testSendOptionalTo() {
        let sender = ValueHolder<Int?>(0)
        let receiver = ValueHolder(10)
        
        let observer = sender.chain().sendTo(receiver).sync()
        
        XCTAssertEqual(receiver.value, 0)
        
        sender.value = nil
        
        XCTAssertEqual(receiver.value, 0)
        
        observer.invalidate()
    }
    
    func testSendOptionalXTo_tuple2() {
        let sender = ValueHolder((Optional(0),
                                  Optional("1")))
        
        let receiver0 = ValueHolder(10)
        let receiver1 = ValueHolder("11")
        
        let observer = sender.chain()
            .send0To(receiver0)
            .send1To(receiver1)
            .sync()
        
        XCTAssertEqual(receiver0.value, 0)
        XCTAssertEqual(receiver1.value, "1")
        
        observer.invalidate()
    }
    
    func testSendOptionalXTo_tuple3() {
        let sender = ValueHolder((Optional(0),
                                  Optional("1"),
                                  Optional(2.0)))
        
        let receiver0 = ValueHolder(10)
        let receiver1 = ValueHolder("11")
        let receiver2 = ValueHolder(12.0)
        
        let observer = sender.chain()
            .send0To(receiver0)
            .send1To(receiver1)
            .send2To(receiver2)
            .sync()
        
        XCTAssertEqual(receiver0.value, 0)
        XCTAssertEqual(receiver1.value, "1")
        XCTAssertEqual(receiver2.value, 2.0)
        
        observer.invalidate()
    }
    
    func testSendOptionalXTo_tuple4() {
        let sender0 = ValueHolder((Optional(0),
                                   Optional("1"),
                                   Optional(2.0),
                                   Optional(3)))
        
        let receiver0 = ValueHolder(10)
        let receiver1 = ValueHolder("11")
        let receiver2 = ValueHolder(12.0)
        let receiver3 = ValueHolder(13)
        
        let observer = sender0.chain()
            .send0To(receiver0)
            .send1To(receiver1)
            .send2To(receiver2)
            .send3To(receiver3)
            .sync()
        
        XCTAssertEqual(receiver0.value, 0)
        XCTAssertEqual(receiver1.value, "1")
        XCTAssertEqual(receiver2.value, 2.0)
        XCTAssertEqual(receiver3.value, 3)
        
        observer.invalidate()
    }
    
    func testSendOptionalXTo_tuple5() {
        let sender = ValueHolder((Optional(0),
                                  Optional("1"),
                                  Optional(2.0),
                                  Optional(3),
                                  Optional("4")))
        
        let receiver0 = ValueHolder(10)
        let receiver1 = ValueHolder("11")
        let receiver2 = ValueHolder(12.0)
        let receiver3 = ValueHolder(13)
        let receiver4 = ValueHolder("14")
        
        let observer = sender.chain()
            .send0To(receiver0)
            .send1To(receiver1)
            .send2To(receiver2)
            .send3To(receiver3)
            .send4To(receiver4)
            .sync()
        
        XCTAssertEqual(receiver0.value, 0)
        XCTAssertEqual(receiver1.value, "1")
        XCTAssertEqual(receiver2.value, 2.0)
        XCTAssertEqual(receiver3.value, 3)
        XCTAssertEqual(receiver4.value, "4")
        
        observer.invalidate()
    }
    
    func testSendToOptional() {
        let sender = ValueHolder(0)
        let receiver = ValueHolder<Int?>(nil)
        
        let observer = sender.chain().sendTo(receiver).sync()
        
        XCTAssertEqual(receiver.value, 0)
        
        observer.invalidate()
    }
    
    func testSendXToOptional_tuple2() {
        let sender0 = ValueHolder(0)
        let sender1 = ValueHolder("1")
        
        let receiver0 = ValueHolder<Int?>(10)
        let receiver1 = ValueHolder<String?>("11")
        
        let observer = sender0.chain()
            .combine(sender1.chain())
            .send0To(receiver0)
            .send1To(receiver1)
            .sync()
        
        XCTAssertEqual(receiver0.value, 0)
        XCTAssertEqual(receiver1.value, "1")
        
        observer.invalidate()
    }
    
    func testSendXToOptional_tuple3() {
        let sender0 = ValueHolder(0)
        let sender1 = ValueHolder("1")
        let sender2 = ValueHolder(2.0)
        
        let receiver0 = ValueHolder<Int?>(10)
        let receiver1 = ValueHolder<String?>("11")
        let receiver2 = ValueHolder<Double?>(12.0)
        
        let observer = sender0.chain()
            .combine(sender1.chain())
            .combine(sender2.chain())
            .send0To(receiver0)
            .send1To(receiver1)
            .send2To(receiver2)
            .sync()
        
        XCTAssertEqual(receiver0.value, 0)
        XCTAssertEqual(receiver1.value, "1")
        XCTAssertEqual(receiver2.value, 2.0)
        
        observer.invalidate()
    }
    
    func testSendXToOptional_tuple4() {
        let sender0 = ValueHolder(0)
        let sender1 = ValueHolder("1")
        let sender2 = ValueHolder(2.0)
        let sender3 = ValueHolder(3)
        
        let receiver0 = ValueHolder<Int?>(10)
        let receiver1 = ValueHolder<String?>("11")
        let receiver2 = ValueHolder<Double?>(12.0)
        let receiver3 = ValueHolder<Int?>(13)
        
        let observer = sender0.chain()
            .combine(sender1.chain())
            .combine(sender2.chain())
            .combine(sender3.chain())
            .send0To(receiver0)
            .send1To(receiver1)
            .send2To(receiver2)
            .send3To(receiver3)
            .sync()
        
        XCTAssertEqual(receiver0.value, 0)
        XCTAssertEqual(receiver1.value, "1")
        XCTAssertEqual(receiver2.value, 2.0)
        XCTAssertEqual(receiver3.value, 3)
        
        observer.invalidate()
    }
    
    func testSendXToOptional_tuple5() {
        let sender0 = ValueHolder(0)
        let sender1 = ValueHolder("1")
        let sender2 = ValueHolder(2.0)
        let sender3 = ValueHolder(3)
        let sender4 = ValueHolder("4")
        
        let receiver0 = ValueHolder<Int?>(10)
        let receiver1 = ValueHolder<String?>("11")
        let receiver2 = ValueHolder<Double?>(12.0)
        let receiver3 = ValueHolder<Int?>(13)
        let receiver4 = ValueHolder<String?>("14")
        
        let observer = sender0.chain()
            .combine(sender1.chain())
            .combine(sender2.chain())
            .combine(sender3.chain())
            .combine(sender4.chain())
            .send0To(receiver0)
            .send1To(receiver1)
            .send2To(receiver2)
            .send3To(receiver3)
            .send4To(receiver4)
            .sync()
        
        XCTAssertEqual(receiver0.value, 0)
        XCTAssertEqual(receiver1.value, "1")
        XCTAssertEqual(receiver2.value, 2.0)
        XCTAssertEqual(receiver3.value, 3)
        XCTAssertEqual(receiver4.value, "4")
        
        observer.invalidate()
    }
}
