import UIKit
import Chaining

let holder = ValueHolder(0)

let observer = holder.chain().do { print("\($0)") }.sync()

holder.value = 1

observer.invalidate()
