# SwiftChaining

## Example

1. Open `SwiftChaining_ios.xcworkspace`.  
2. Select scheme `SwiftChaining_ios_example`.  
3. Run.

## Requirements

Swift4.2  

## Installation

SwiftChaining is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Chaining'
```

## License

SwiftChaining is available under the MIT license. See the LICENSE file for more info.

# Code Samples
## Import
```swift
import Chaining
```

## Protocols

### Chainable
```swift
public protocol Chainable: class {
    associatedtype ChainValue
    typealias BeginChain = Chain<ChainValue, Self>
}

extension Chainable {
    public func retain() -> Retainer<Self> { ... }
    public func chain() -> BeginChain { ... }
}
```

### Sendable
```swift
public protocol Sendable: Chainable {
}

extension Sendable {
    public func broadcast(value: ChainValue) { ... }
}
```
```swift
class MySender: Sendable {
    // 送信する値の型を指定する
    typealias SendValue = Int
}

let sender = MySender()

// chain()の後に値が送信された時の処理をメソッドチェーンで記述しend()で確定させる
let observer = sender.chain().do { print($0) }.end()

// broadcastで値を送信する
sender.broadcast(value: 1)
```
### Fetchable
```swift
public protocol Fetchable: Chainable {
    func fetchedValue() -> ChainValue
    func canFetch() -> Bool
}

extension Fetchable {
    public func canFetch() -> Bool {
        return true
    }
}
```
```swift
class MyFetcher: Fetchable {
    // 送信する値の型を指定する
    typealias SendValue = Int

    // 送信する値を返す
    func fetchedValue() -> SendValue {
        return 1
    }
}

let fetcher = MyFetcher()

// sync()でfetchedValue()の値を取得し送信する
let observer = fetcher.chain().do { print($0) }.sync()
```
### Syncable
```swift
public typealias Syncable = Fetchable & Sendable
```

### Receivable
```swift
public typealias Receivable = ValueReceivable & ReceiveReferencable

public protocol ValueReceivable: class {
    associatedtype ReceiveValue

    func receive(value: ReceiveValue)
}
```
```swift
class MyReceiver: Receivable {
    // 受信する型を指定する
    typealias ReceiveValue = Int

    // 受信した時の処理
    func receive(value: Int) {
        print(value)
    }
}

let receiver = MyReceiver()

let notifier = Notifier<Int>()

// sendToで値を受信する
let observer = notifier.chain().sendTo(receiver).end()

notifier.notify(value: 1)
```
### AnyObserver
```swift
public protocol AnyObserver: class {
    func invalidate()
}
```
```swift
let notifier = Notifier<Int>()

// endを呼ぶと処理の流れが確定しobserverが返る
let observer: AnyObserver = notifier.chain().do { print($0) }.end()

// 送信される
notifier.notify(value: 1)

// invalidateを呼ぶと送信されなくなる
observer.invalidate()

// 送信されない
notifier.notify(value: 2)

let holder = ValueHolder("initial")

do {
    // syncを呼ぶと処理の流れが確定しobserverが返る
    let observer: AnyObserver = holder.chain().do { print($0) }.sync()

    // 送信される
    holder.value = "send"
}

// observerが解放されると送信されない
holder.value = "not send"
```
## Classes
### Notifier: Sendable, Receivable
```swift
let notifier = Notifier<Int>()

let observer = notifier.chain().do { print($0) }.end()

// notify(value:)で値を送信
notifier.notify(value: 1)
```
### Fetcher: Syncable, Receivable
```swift
// 送信する値をクロージャで返す
let fetcher = Fetcher { 1 }

// sync()で値が送信される
let observer = fetcher.chain().do { print($0) }.sync()

// 強制的に送信
fetcher.broadcast()
```
### ValueHolder: Syncable, Receivable
```swift
let holder = ValueHolder(0)

// sync()で保持している値を送信
let observer = holder.chain().do { print($0) }.sync()

// 値をセットすると送信される
holder.value = 1
```
### ObserverPool: AnyObserver
```swift
let observerPool = ObserverPool()

let notifier = Notifier<Int>()

// add()またはaddTo()でObserverPoolにObserverを追加
observerPool.add(notifier.chain().do { print("a:\($0)") }.end())
notifier.chain().do { print("b:\($0)") }.end().addTo(observerPool)

// 送信される
notifier.notify(value: 1)

// 登録されたObserverのinvalidateがまとめて呼ばれる
observerPool.invalidate()

// 送信されない
notifier.notify(value: 2)
```
### ArrayHolder: Syncable
```swift
let holder = ArrayHolder([0, 1, 2])

// sync()でfetchedが送信される
let observer = holder
    .chain()
    .do {
        switch $0 {
        case .fetched(let elements):
            print("fetched:\(elements)")
        case .any(let elements):
            print("any:\(elements)")
        case .inserted(let index, let element):
            print("inserted at:\(index) element:\(element)")
        case .removed(let index, let element):
            print("removed at:\(index) element:\(element)")
        case .replaced(let index, let element):
            print("replaced at:\(index) element:\(element)")
        case .moved(let fromIndex, let toIndex, let element):
            print("moved from:\(fromIndex) to:\(toIndex) element:\(element)")
        }
    }
    .sync()

// insertedが送信される
holder.append(3)

// removedが送信される
holder.remove(at: 2)

// replacedが送信される
holder.replace(4, at: 1)

// movedが送信される
holder.move(at: 0, to: 2)

// anyが送信される
holder.replace([0, 1])
```
### NotificationAdapter: Sendable
```swift
class MyNotifier {
    static let name = Notification.Name("TestName")

    func post() {
        NotificationCenter.default.post(name: MyNotifier.name, object: self)
    }
}

let object = MyNotifier()

let adapter = NotificationAdapter(MyNotifier.name, object: object)

let observer = adapter.chain().do { print($0) }.end()

object.post()
```
### KVOAdapter: Syncable
```swift
class MyObject: NSObject {
    @objc dynamic var value: Int = 0
}

let object = MyObject()

let adapter = KVOAdapter(object, keyPath: \MyObject.value)

let observer = adapter.chain().do { print("do:\($0)") }.sync()

// 元のオブジェクトの値を変更すると値が送信される
object.value = 1

// Adapterのvalueを変更すると元のオブジェクトの値が変更され送信される
adapter.value = 2

// 2になっている
print("object.value:\(object.value)")
```
### UIControlAdapter: Sendable
```swift
class MyViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    lazy var adapter = { UIControlAdapter(button, events: .touchUpInside) }()
    var observer: AnyObserver?

    override func viewDidLoad() {
        super.viewDidLoad()

        // ボタンをタップすると送信される
        self.observer = self.adapter.chain().do { print($0) }.end()
    }
}
```
### Retainer
```swift
// retain()を呼ぶことでAdapterがObserverに保持される
let observer = NotificationAdapter(name)
    .retain()
    .chain()
    .do { ... }
    .end()
```
```swift
let holder = ValueHolder(0)

// retain()を呼ぶことでholderがObserverに保持される
let observer = holder.chain()
    .sendTo(holder.retain())
    .end()
```
## Chain Methods
### do
```swift
let notifier = Notifier<Int>()

let observer =
    notifier
        .chain()
        .do { value in
            // 送信されたイベントを引数で受け取って実行する
            print("print:\(value)")
        }
        .end()

notifier.notify(value: 1)
```
### end
```swift
let notifier = Notifier<Int>()

// end()で処理の流れを確定しObserverを返す
let observer = notifier.chain().do { print($0) }.end()
```
### sync (Fetchable Only)
```swift
let holder = ValueHolder(0)

// sync()で処理の流れを確定し1回送信してObserverを返す
let observer = holder.chain().do { print($0) }.sync()
```
### sendTo
```swift
let sender = Notifier<Int>()
let receiver = ValueHolder(0)

// sendToでreceiverが値を受け取る
let observer = sender.chain().sendTo(receiver).end()

sender.notify(value: 1)

// 値は1になっている
print(receiver.value)
```
### map
```swift
let notifier = Notifier<Int>()
let stringHolder = ValueHolder("")

// mapで値を変換する
let observer = notifier.chain().map { intValue in "StringValue:\(intValue)" }.sendTo(stringHolder).end()

notifier.notify(value: 1)

// 値が"StringValue:1"になっている
print(stringHolder.value)
```
### guard / filter
```swift
let notifier = Notifier<Int>()

// guardでfalseを返すと以降の処理は実行されない
let observer = notifier.chain().guard { $0 % 2 != 0 }.do { print($0) }.end()

// guardでtrueが返されるので実行される
notifier.notify(value: 1)

// guardでfalseが返されるので実行されない
notifier.notify(value: 2)
```
### merge
```swift
let notifier1 = Notifier<Int>()
let notifier2 = Notifier<Int>()
let holder = ValueHolder(0)

let chain1 = notifier1.chain()
let chain2 = notifier2.chain()

// mergeで同じ型の処理の流れをひとつにまとめる
let observer = chain1.merge(chain2).sendTo(holder).end()

notifier1.notify(value: 1)

// holderの値が1になっている
print(holder.value)

notifier2.notify(value: 2)

// holderの値が2になっている
print(holder.value)
```
### tuple
```swift
let notifier1 = Notifier<Int>()
let notifier2 = Notifier<String>()
let chain1 = notifier1.chain()
let chain2 = notifier2.chain()

// 違う型の値をひとつのtupleにまとめる
let observer = chain1
    .tuple(chain2)
    .do { (lhs, rhs) in
        // lhsかrhsのどちらかにOptionalで値が渡される
        if let lhs = lhs {
            print("Int:\(lhs)")
        } else if let rhs = rhs {
            print("String:\(rhs)")
        }
    }.end()

// "Int:1"がprintされる
notifier1.notify(value: 1)

// "String:2"がprintされる
notifier2.notify(value: "2")
```
### combine
```swift
let notifier1 = Notifier<Int>()
let notifier2 = Notifier<String>()
let chain1 = notifier1.chain()
let chain2 = notifier2.chain()

// combineで違う型の値をひとつのtupleにまとめる
let observer = chain1
    .combine(chain2)
    .do { (lhs, rhs) in
        // 両方の値が揃ったら実行される
        print("\(lhs):\(rhs)")
    }.end()

// 片方しか送信していないので実行されない
notifier1.notify(value: 1)

// 両方揃ったので実行される
notifier2.notify(value: "2")
```
