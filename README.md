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

### Sendable
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
### Fetchable: Sendable
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

// broadcastで値を送信する
sender.broadcast(value: 2)
```
### Receivable
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
### Fetcher: Fetchable, Receivable
```swift
// 送信する値をクロージャで返す
let fetcher = Fetcher { 1 }

// sync()で値が送信される
let observer = fetcher.chain().do { print($0) }.sync()

// 強制的に送信
fetcher.broadcast()
```
### ValueHolder: Fetchable, Receivable
```swift
let holder = ValueHolder(0)

// sync()で保持している値を送信
let observer = holder.chain().do { print($0) }.sync()

// 値をセットすると送信される
holder.value = 1
```
### ObserverPool: AnyObserver
```swift
var observerPool = ObserverPool()

let notifier = Notifier<Int>()

// add()または+=でObserverPoolにObserverを追加
observerPool.add(notifier.chain().do { print("a:\($0)") }.end())
observerPool += notifier.chain().do { print("b:\($0)") }.end()

// 送信される
notifier.notify(value: 1)

// 登録されたObserverのinvalidateがまとめて呼ばれる
observerPool.invalidate()

// 送信されない
notifier.notify(value: 2)
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
### guard
```swift
let notifier = Notifier<Int>()

// guardでfalseを返すと以降の処理は実行されない
let observer = notifier.chain().guard { $0 % 2 != 0 }.do { print($0) }.end()

// 奇数なので実行される
notifier.notify(value: 1)

// 偶数なので実行されない
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
### pair
```swift
let notifier1 = Notifier<Int>()
let notifier2 = Notifier<String>()
let chain1 = notifier1.chain()
let chain2 = notifier2.chain()

// pairで違う型のイベントをひとつのtupleにまとめる
let observer = chain1
    .pair(chain2)
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

// combineで違う型の値をひとつにまとめる
let observer = chain1
    .combine(chain2)
    .do { (lhs, rhs) in
        // 両方の値が揃ったら送信される
        print("\(lhs):\(rhs)")
    }.end()

// 片方しか送信していないのでprintされない
notifier1.notify(value: 1)

// 両方揃ったのでprintされる
notifier2.notify(value: "2")
```
