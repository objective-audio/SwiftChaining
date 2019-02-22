//
//  PairTests.swift
//

import XCTest
import Chaining

class TupleTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEachFetchable() {
        let main = ValueHolder<Int>(1)
        let sub = ValueHolder<String>("2")
        
        var received: [(Int?, String?)] = []
        
        let observer = main.chain().tuple(sub.chain()).do { received.append($0) }.sync()
        
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[0].0, 1)
        XCTAssertNil(received[0].1)
        XCTAssertNil(received[1].0)
        XCTAssertEqual(received[1].1, "2")
        
        observer.invalidate()
    }
    
    func testMainFetchable() {
        let main = ValueHolder<Int>(0)
        let sub = Notifier<String>()
        
        var received: (Int?, String?)?
        
        let observer = main.chain().tuple(sub.chain()).do { received = $0 }.sync()
        
        XCTAssertEqual(received?.0, 0)
        XCTAssertNil(received?.1)
        
        main.value = 1
        
        XCTAssertEqual(received?.0, 1)
        XCTAssertNil(received?.1)
        
        sub.notify(value: "2")
        
        XCTAssertNil(received?.0)
        XCTAssertEqual(received?.1, "2")
        
        observer.invalidate()
    }
    
    func testSubFetchable() {
        let main = Notifier<Int>()
        let sub = ValueHolder<String>("")
        
        var received: (Int?, String?)?
        
        let observer = main.chain().tuple(sub.chain()).do { received = $0 }.sync()
        
        XCTAssertNil(received?.0)
        XCTAssertEqual(received?.1, "")
        
        main.notify(value: 1)
        
        XCTAssertEqual(received?.0, 1)
        XCTAssertNil(received?.1)
        
        sub.value = "2"
        
        XCTAssertNil(received?.0)
        XCTAssertEqual(received?.1, "2")
        
        observer.invalidate()
    }
    
    func testNoFetchable() {
        let main = Notifier<Int>()
        let sub = Notifier<String>()
        
        var received: (Int?, String?)?
        
        let observer = main.chain().tuple(sub.chain()).do { received = $0 }.end()
        
        XCTAssertNil(received)
        
        main.notify(value: 1)
        
        XCTAssertEqual(received?.0, 1)
        XCTAssertNil(received?.1)
        
        sub.notify(value: "2")
        
        XCTAssertNil(received?.0)
        XCTAssertEqual(received?.1, "2")
        
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
            var received: [(Int?, Int?, Int?)] = []
            
            let observer = holder0.chain()
                .tuple(holder1.chain())
                .tuple(holder2.chain())
                .do { received.append($0) }.sync()
            
            XCTAssertEqual(received.count, 3)
            
            XCTAssertEqual(received[0].0, 0)
            XCTAssertNil(received[0].1)
            XCTAssertNil(received[0].2)
            
            XCTAssertNil(received[1].0)
            XCTAssertEqual(received[1].1, 1)
            XCTAssertNil(received[1].2)
            
            XCTAssertNil(received[2].0)
            XCTAssertNil(received[2].1)
            XCTAssertEqual(received[2].2, 2)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int?, Int?, Int?)] = []
            
            let observer = holder0.chain()
                .tuple(holder1.chain())
                .tuple(notifier2.chain())
                .do { received.append($0) }.sync()
            
            XCTAssertEqual(received.count, 2)
            
            XCTAssertEqual(received[0].0, 0)
            XCTAssertNil(received[0].1)
            XCTAssertNil(received[0].2)
            
            XCTAssertNil(received[1].0)
            XCTAssertEqual(received[1].1, 1)
            XCTAssertNil(received[1].2)
            
            notifier2.notify(value: 2)
            
            XCTAssertEqual(received.count, 3)
            
            XCTAssertNil(received[2].0)
            XCTAssertNil(received[2].1)
            XCTAssertEqual(received[2].2, 2)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int?, Int?, Int?)] = []
            
            let observer = notifier0.chain()
                .tuple(notifier1.chain())
                .tuple(holder2.chain())
                .do { received.append($0) }.sync()
            
            XCTAssertEqual(received.count, 1)
            
            XCTAssertNil(received[0].0)
            XCTAssertNil(received[0].1)
            XCTAssertEqual(received[0].2, 2)
            
            notifier0.notify(value: 0)
            
            XCTAssertEqual(received.count, 2)
            
            XCTAssertEqual(received[1].0, 0)
            XCTAssertNil(received[1].1)
            XCTAssertNil(received[1].2)
            
            notifier1.notify(value: 1)
            
            XCTAssertEqual(received.count, 3)
            
            XCTAssertNil(received[2].0)
            XCTAssertEqual(received[2].1, 1)
            XCTAssertNil(received[2].2)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int?, Int?, Int?)] = []
            
            let observer = notifier0.chain()
                .tuple(notifier1.chain())
                .tuple(notifier2.chain())
                .do { received.append($0) }.end()
            
            XCTAssertEqual(received.count, 0)
            
            notifier0.notify(value: 0)
            
            XCTAssertEqual(received.count, 1)
            
            XCTAssertEqual(received[0].0, 0)
            XCTAssertNil(received[0].1)
            XCTAssertNil(received[0].2)
            
            notifier1.notify(value: 1)
            
            XCTAssertEqual(received.count, 2)
            
            XCTAssertNil(received[1].0)
            XCTAssertEqual(received[1].1, 1)
            XCTAssertNil(received[1].2)
            
            notifier2.notify(value: 2)
            
            XCTAssertEqual(received.count, 3)
            
            XCTAssertNil(received[2].0)
            XCTAssertNil(received[2].1)
            XCTAssertEqual(received[2].2, 2)
            
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
            var received: [(Int?, Int?, Int?, Int?)] = []
            
            let observer = holder0.chain()
                .tuple(holder1.chain())
                .tuple(holder2.chain())
                .tuple(holder3.chain())
                .do { received.append($0) }.sync()
            
            XCTAssertEqual(received.count, 4)
            
            XCTAssertEqual(received[0].0, 0)
            XCTAssertNil(received[0].1)
            XCTAssertNil(received[0].2)
            XCTAssertNil(received[0].3)
            
            XCTAssertNil(received[1].0)
            XCTAssertEqual(received[1].1, 1)
            XCTAssertNil(received[1].2)
            XCTAssertNil(received[1].3)
            
            XCTAssertNil(received[2].0)
            XCTAssertNil(received[2].1)
            XCTAssertEqual(received[2].2, 2)
            XCTAssertNil(received[2].3)
            
            XCTAssertNil(received[3].0)
            XCTAssertNil(received[3].1)
            XCTAssertNil(received[3].2)
            XCTAssertEqual(received[3].3, 3)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int?, Int?, Int?, Int?)] = []
            
            let observer = holder0.chain()
                .tuple(holder1.chain())
                .tuple(holder2.chain())
                .tuple(notifier3.chain())
                .do { received.append($0) }.sync()
            
            XCTAssertEqual(received.count, 3)
            
            XCTAssertEqual(received[0].0, 0)
            XCTAssertNil(received[0].1)
            XCTAssertNil(received[0].2)
            XCTAssertNil(received[0].3)
            
            XCTAssertNil(received[1].0)
            XCTAssertEqual(received[1].1, 1)
            XCTAssertNil(received[1].2)
            XCTAssertNil(received[1].3)
            
            XCTAssertNil(received[2].0)
            XCTAssertNil(received[2].1)
            XCTAssertEqual(received[2].2, 2)
            XCTAssertNil(received[2].3)
            
            notifier3.notify(value: 3)
            
            XCTAssertEqual(received.count, 4)
            
            XCTAssertNil(received[3].0)
            XCTAssertNil(received[3].1)
            XCTAssertNil(received[3].2)
            XCTAssertEqual(received[3].3, 3)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int?, Int?, Int?, Int?)] = []
            
            let observer = notifier0.chain()
                .tuple(notifier1.chain())
                .tuple(notifier2.chain())
                .tuple(holder3.chain())
                .do { received.append($0) }.sync()
            
            XCTAssertEqual(received.count, 1)
            
            XCTAssertNil(received[0].0)
            XCTAssertNil(received[0].1)
            XCTAssertNil(received[0].2)
            XCTAssertEqual(received[0].3, 3)
            
            notifier0.notify(value: 0)
            
            XCTAssertEqual(received.count, 2)
            
            XCTAssertEqual(received[1].0, 0)
            XCTAssertNil(received[1].1)
            XCTAssertNil(received[1].2)
            XCTAssertNil(received[1].3)
            
            notifier1.notify(value: 1)
            
            XCTAssertEqual(received.count, 3)
            
            XCTAssertNil(received[2].0)
            XCTAssertEqual(received[2].1, 1)
            XCTAssertNil(received[2].2)
            XCTAssertNil(received[2].3)
            
            notifier2.notify(value: 2)
            
            XCTAssertEqual(received.count, 4)
            
            XCTAssertNil(received[3].0)
            XCTAssertNil(received[3].1)
            XCTAssertEqual(received[3].2, 2)
            XCTAssertNil(received[3].3)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int?, Int?, Int?, Int?)] = []
            
            let observer = notifier0.chain()
                .tuple(notifier1.chain())
                .tuple(notifier2.chain())
                .tuple(notifier3.chain())
                .do { received.append($0) }.end()
            
            XCTAssertEqual(received.count, 0)
            
            notifier0.notify(value: 0)
            
            XCTAssertEqual(received.count, 1)
            
            XCTAssertEqual(received[0].0, 0)
            XCTAssertNil(received[0].1)
            XCTAssertNil(received[0].2)
            XCTAssertNil(received[0].3)
            
            notifier1.notify(value: 1)
            
            XCTAssertEqual(received.count, 2)
            
            XCTAssertNil(received[1].0)
            XCTAssertEqual(received[1].1, 1)
            XCTAssertNil(received[1].2)
            XCTAssertNil(received[1].3)
            
            notifier2.notify(value: 2)
            
            XCTAssertEqual(received.count, 3)
            
            XCTAssertNil(received[2].0)
            XCTAssertNil(received[2].1)
            XCTAssertEqual(received[2].2, 2)
            XCTAssertNil(received[2].3)
            
            notifier3.notify(value: 3)
            
            XCTAssertEqual(received.count, 4)
            
            XCTAssertNil(received[3].0)
            XCTAssertNil(received[3].1)
            XCTAssertNil(received[3].2)
            XCTAssertEqual(received[3].3, 3)
            
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
            var received: [(Int?, Int?, Int?, Int?, Int?)] = []
            
            let observer = holder0.chain()
                .tuple(holder1.chain())
                .tuple(holder2.chain())
                .tuple(holder3.chain())
                .tuple(holder4.chain())
                .do { received.append($0) }.sync()
            
            XCTAssertEqual(received.count, 5)
            
            XCTAssertEqual(received[0].0, 0)
            XCTAssertNil(received[0].1)
            XCTAssertNil(received[0].2)
            XCTAssertNil(received[0].3)
            XCTAssertNil(received[0].4)
            
            XCTAssertNil(received[1].0)
            XCTAssertEqual(received[1].1, 1)
            XCTAssertNil(received[1].2)
            XCTAssertNil(received[1].3)
            XCTAssertNil(received[1].4)
            
            XCTAssertNil(received[2].0)
            XCTAssertNil(received[2].1)
            XCTAssertEqual(received[2].2, 2)
            XCTAssertNil(received[2].3)
            XCTAssertNil(received[2].4)
            
            XCTAssertNil(received[3].0)
            XCTAssertNil(received[3].1)
            XCTAssertNil(received[3].2)
            XCTAssertEqual(received[3].3, 3)
            XCTAssertNil(received[3].4)
            
            XCTAssertNil(received[4].0)
            XCTAssertNil(received[4].1)
            XCTAssertNil(received[4].2)
            XCTAssertNil(received[4].3)
            XCTAssertEqual(received[4].4, 4)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int?, Int?, Int?, Int?, Int?)] = []
            
            let observer = holder0.chain()
                .tuple(holder1.chain())
                .tuple(holder2.chain())
                .tuple(holder3.chain())
                .tuple(notifier4.chain())
                .do { received.append($0) }.sync()
            
            XCTAssertEqual(received.count, 4)
            
            XCTAssertEqual(received[0].0, 0)
            XCTAssertNil(received[0].1)
            XCTAssertNil(received[0].2)
            XCTAssertNil(received[0].3)
            XCTAssertNil(received[0].4)
            
            XCTAssertNil(received[1].0)
            XCTAssertEqual(received[1].1, 1)
            XCTAssertNil(received[1].2)
            XCTAssertNil(received[1].3)
            XCTAssertNil(received[1].4)
            
            XCTAssertNil(received[2].0)
            XCTAssertNil(received[2].1)
            XCTAssertEqual(received[2].2, 2)
            XCTAssertNil(received[2].3)
            XCTAssertNil(received[2].4)
            
            XCTAssertNil(received[3].0)
            XCTAssertNil(received[3].1)
            XCTAssertNil(received[3].2)
            XCTAssertEqual(received[3].3, 3)
            XCTAssertNil(received[3].4)
            
            notifier4.notify(value: 4)
            
            XCTAssertEqual(received.count, 5)
            
            XCTAssertNil(received[4].0)
            XCTAssertNil(received[4].1)
            XCTAssertNil(received[4].2)
            XCTAssertNil(received[4].3)
            XCTAssertEqual(received[4].4, 4)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int?, Int?, Int?, Int?, Int?)] = []
            
            let observer = notifier0.chain()
                .tuple(notifier1.chain())
                .tuple(notifier2.chain())
                .tuple(notifier3.chain())
                .tuple(holder4.chain())
                .do { received.append($0) }.sync()
            
            XCTAssertEqual(received.count, 1)
            
            XCTAssertNil(received[0].0)
            XCTAssertNil(received[0].1)
            XCTAssertNil(received[0].2)
            XCTAssertNil(received[0].3)
            XCTAssertEqual(received[0].4, 4)
            
            notifier0.notify(value: 0)
            
            XCTAssertEqual(received.count, 2)
            
            XCTAssertEqual(received[1].0, 0)
            XCTAssertNil(received[1].1)
            XCTAssertNil(received[1].2)
            XCTAssertNil(received[1].3)
            XCTAssertNil(received[1].4)
            
            notifier1.notify(value: 1)
            
            XCTAssertEqual(received.count, 3)
            
            XCTAssertNil(received[2].0)
            XCTAssertEqual(received[2].1, 1)
            XCTAssertNil(received[2].2)
            XCTAssertNil(received[2].3)
            XCTAssertNil(received[2].4)
            
            notifier2.notify(value: 2)
            
            XCTAssertEqual(received.count, 4)
            
            XCTAssertNil(received[3].0)
            XCTAssertNil(received[3].1)
            XCTAssertEqual(received[3].2, 2)
            XCTAssertNil(received[3].3)
            XCTAssertNil(received[3].4)
            
            notifier3.notify(value: 3)
            
            XCTAssertEqual(received.count, 5)
            
            XCTAssertNil(received[4].0)
            XCTAssertNil(received[4].1)
            XCTAssertNil(received[4].2)
            XCTAssertEqual(received[4].3, 3)
            XCTAssertNil(received[4].4)
            
            observer.invalidate()
        }
        
        do {
            var received: [(Int?, Int?, Int?, Int?, Int?)] = []
            
            let observer = notifier0.chain()
                .tuple(notifier1.chain())
                .tuple(notifier2.chain())
                .tuple(notifier3.chain())
                .tuple(notifier4.chain())
                .do { received.append($0) }.end()
            
            XCTAssertEqual(received.count, 0)
            
            notifier0.notify(value: 0)
            
            XCTAssertEqual(received.count, 1)
            
            XCTAssertEqual(received[0].0, 0)
            XCTAssertNil(received[0].1)
            XCTAssertNil(received[0].2)
            XCTAssertNil(received[0].3)
            XCTAssertNil(received[0].4)
            
            notifier1.notify(value: 1)
            
            XCTAssertEqual(received.count, 2)
            
            XCTAssertNil(received[1].0)
            XCTAssertEqual(received[1].1, 1)
            XCTAssertNil(received[1].2)
            XCTAssertNil(received[1].3)
            XCTAssertNil(received[1].4)
            
            notifier2.notify(value: 2)
            
            XCTAssertEqual(received.count, 3)
            
            XCTAssertNil(received[2].0)
            XCTAssertNil(received[2].1)
            XCTAssertEqual(received[2].2, 2)
            XCTAssertNil(received[2].3)
            XCTAssertNil(received[2].4)
            
            notifier3.notify(value: 3)
            
            XCTAssertEqual(received.count, 4)
            
            XCTAssertNil(received[3].0)
            XCTAssertNil(received[3].1)
            XCTAssertNil(received[3].2)
            XCTAssertEqual(received[3].3, 3)
            XCTAssertNil(received[3].4)
            
            notifier4.notify(value: 4)
            
            XCTAssertEqual(received.count, 5)
            
            XCTAssertNil(received[4].0)
            XCTAssertNil(received[4].1)
            XCTAssertNil(received[4].2)
            XCTAssertNil(received[4].3)
            XCTAssertEqual(received[4].4, 4)
            
            observer.invalidate()
        }
    }
}
