//
//  KVOAdapterTests.swift
//

import XCTest
import Chaining

fileprivate class TestObject: NSObject {
    @objc dynamic var text: String = "initial"
    @objc dynamic var number: Int = 0
    @objc dynamic var optText: String? = nil
}

class KVOAdapterTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSetByOriginal() {
        let object = TestObject()
        
        let adapter = KVOAdapter(object, keyPath: \.text)
        
        var received: [String] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "initial")
        
        object.text = "test_value"
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], "test_value")
        
        observer.invalidate()
    }
    
    func testSetByAdapter() {
        let object = TestObject()
        
        let adapter = KVOAdapter(object, keyPath: \.text)
        
        var received: [String] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "initial")
        
        adapter.value = "test_value"
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], "test_value")
        
        observer.invalidate()
    }
    
    func testValue() {
        let object = TestObject()
        
        let adapter = KVOAdapter(object, keyPath: \.text)
        
        XCTAssertEqual(adapter.value, "initial")
    }
    
    func testSafeValue() {
        var adapter: KVOAdapter<TestObject, String>?
        
        do {
            let object = TestObject()
            
            adapter = KVOAdapter(object, keyPath: \.text)
            
            XCTAssertEqual(adapter?.safeValue, "initial")
        }
        
        XCTAssertNotNil(adapter)
        XCTAssertNil(adapter?.safeValue)
    }
    
    func testInvalidate() {
        let object = TestObject()
        
        let adapter = KVOAdapter(object, keyPath: \.text)
        
        var received: [String] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "initial")
        
        adapter.invalidate()
        
        XCTAssertNil(adapter.safeValue)
        
        object.text = "test_value"
        
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
    
    func testDeinit() {
        let object = TestObject()
        
        var received: [String] = []
        
        do {
            let adapter = KVOAdapter(object, keyPath: \.text)
            
            let observer = adapter.chain().do { received.append($0) }.sync()
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0], "initial")
            
            object.text = "test_value_1"
            
            XCTAssertEqual(received.count, 2)
            XCTAssertEqual(received[1], "test_value_1")
            
            observer.invalidate()
        }
        
        object.text = "test_value_2"
        
        XCTAssertEqual(received.count, 2)
    }
    
    func testRecursive() {
        let object = TestObject()
        let adapter = KVOAdapter(object, keyPath: \.text)
        
        var received: [String] = []
        
        let observer = adapter.chain().do { received.append($0) }.sendTo(adapter).end()
        
        adapter.value = "test_value"
        
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
    
    func testOptionalValue() {
        let object = TestObject()
        
        let adapter = KVOAdapter(object, keyPath: \.optText)
        
        var received: [String?] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertNil(received[0])
        
        object.optText = "test_value"
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], "test_value")
        
        object.optText = nil
        
        // nilの通知は無視されてしまう
        XCTAssertEqual(received.count, 2)
        
        observer.invalidate()
    }
    
    func testOptionalValueWithDefault() {
        let object = TestObject()
        
        let adapter = KVOAdapter(object, keyPath: \.optText, default: .value(nil))
        
        var received: [String?] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertNil(received[0])
        
        object.optText = "test_value"
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], "test_value")
        
        object.optText = nil
        
        XCTAssertEqual(received.count, 3)
        XCTAssertNil(received[2])
        
        observer.invalidate()
    }
    
    func testUntypedSetByOriginal() {
        let object = TestObject()
        
        let adapter = KVOAdapter<TestObject, String>(object, keyPath: "text")
        
        var received: [String] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "initial")
        
        object.text = "test_value"
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], "test_value")
        
        observer.invalidate()
    }
    
    func testUntypedSetByAdapter() {
        let object = TestObject()
        
        let adapter = KVOAdapter<TestObject, String>(object, keyPath: "text")
        
        var received: [String] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "initial")
        
        adapter.value = "test_value"
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], "test_value")
        
        observer.invalidate()
    }
    
    func testUntypedValue() {
        let object = TestObject()
        
        let adapter = KVOAdapter<TestObject, String>(object, keyPath: "text")
        
        XCTAssertEqual(adapter.value, "initial")
    }
    
    func testUntypedSafeValueNilValue() {
        let key = "test_key"
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(nil, forKey: key)
        
        let adapter = KVOAdapter<UserDefaults, Int>(userDefaults, keyPath: key)
        
        XCTAssertNil(adapter.safeValue)
        
        userDefaults.set(1, forKey: key)
        
        XCTAssertEqual(adapter.safeValue, 1)
        
        userDefaults.set(nil, forKey: key)
    }
    
    func testUntypedSafeValueNilObject() {
        var adapter: KVOAdapter<TestObject, String>?
        
        do {
            let object = TestObject()
            
            adapter = KVOAdapter<TestObject, String>(object, keyPath: "text")
            
            XCTAssertEqual(adapter?.safeValue, "initial")
        }
        
        XCTAssertNotNil(adapter)
        XCTAssertNil(adapter?.safeValue)
    }
    
    func testUntypedInvalidate() {
        let object = TestObject()
        
        let adapter = KVOAdapter<TestObject, String>(object, keyPath: "text")
        
        var received: [String] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "initial")
        
        adapter.invalidate()
        
        XCTAssertNil(adapter.safeValue)
        
        object.text = "test_value"
        
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
    
    func testUntypedDeinit() {
        let object = TestObject()
        
        var received: [String] = []
        
        do {
            let adapter = KVOAdapter<TestObject, String>(object, keyPath: "text")
            
            let observer = adapter.chain().do { received.append($0) }.sync()
            
            XCTAssertEqual(received.count, 1)
            XCTAssertEqual(received[0], "initial")
            
            object.text = "test_value_1"
            
            XCTAssertEqual(received.count, 2)
            XCTAssertEqual(received[1], "test_value_1")
            
            observer.invalidate()
        }
        
        object.text = "test_value_2"
        
        XCTAssertEqual(received.count, 2)
    }
    
    func testUntypedRecursive() {
        let object = TestObject()
        let adapter = KVOAdapter<TestObject, String>(object, keyPath: "text")
        
        var received: [String] = []
        
        let observer = adapter.chain().do { received.append($0) }.sendTo(adapter).end()
        
        adapter.value = "test_value"
        
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
    
    func testUntypedManyChains() {
        let object = TestObject()
        let pool = ObserverPool()
        let textAdapter = KVOAdapter<TestObject, String>(object, keyPath: "text")
        let numberAdapter = KVOAdapter<TestObject, Int>(object, keyPath: "number")
        
        var textReceived: [String] = []
        var numberReceived: [Int] = []
        
        textAdapter.chain().do { textReceived.append($0) }.sync().addTo(pool)
        numberAdapter.chain().do { numberReceived.append($0) }.sync().addTo(pool)
        
        XCTAssertEqual(textReceived.count, 1)
        XCTAssertEqual(textReceived[0], "initial")
        XCTAssertEqual(numberReceived.count, 1)
        XCTAssertEqual(numberReceived[0], 0)
        
        object.text = "test_value"
        
        XCTAssertEqual(textReceived.count, 2)
        XCTAssertEqual(textReceived[1], "test_value")
        XCTAssertEqual(numberReceived.count, 1)
        
        object.number = 1
        
        XCTAssertEqual(textReceived.count, 2)
        XCTAssertEqual(numberReceived.count, 2)
        XCTAssertEqual(numberReceived[1], 1)
        
        pool.invalidate()
    }
    /*
    func testUntypedOptionalValue() {
        let object = TestObject()
        
        let adapter = KVOAdapter<TestObject, String?>(object, keyPath: "optText")
        
        var received: [String?] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        // 値がnilなので通知されない
        XCTAssertEqual(received.count, 0)
        
        object.optText = "test_value"
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0], "test_value")
        
        object.optText = nil
        
        // nilの通知は無視されてしまう
        XCTAssertEqual(received.count, 1)
        
        observer.invalidate()
    }
    */
    func testUntypedOptionalValueWithDefault() {
        let object = TestObject()
        
        let adapter = KVOAdapter<TestObject, String?>(object, keyPath: "optText", default: .value(nil))
        
        var received: [String?] = []
        
        let observer = adapter.chain().do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 1)
        XCTAssertNil(received[0])
        
        object.optText = "test_value"
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[1], "test_value")
        
        object.optText = nil
        
        XCTAssertEqual(received.count, 3)
        XCTAssertNil(received[2])
        
        observer.invalidate()
    }
    
    func testDefaultHasValue() {
        let valueDefault = KVOAdapter<TestObject, String>.Default.value("value")
        let noneDefault = KVOAdapter<TestObject, String>.Default.none
        
        XCTAssertTrue(valueDefault.hasValue)
        XCTAssertFalse(noneDefault.hasValue)
    }
}
