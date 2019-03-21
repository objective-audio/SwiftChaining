//
//  NumbersViewController.swift
//

import UIKit
import Chaining

class NumbersViewController: UIViewController {
    @IBOutlet weak var number1Field: UITextField!
    @IBOutlet weak var number2Field: UITextField!
    @IBOutlet weak var number3Field: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    private typealias TextAdapter = KVOAdapter<UITextField, String?>
    private typealias ChangedAdapter = UIControlAdapter<UITextField>
    
    private var observer: AnyObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let makeChain = { (textAdapter: TextAdapter, changedAdapter: ChangedAdapter) in
            return changedAdapter
                .retain().chain()
                .map { $0.text }
                .merge(textAdapter.retain().chain())
                .map { string in Int(string ?? "") ?? 0 }
        }
        
        let chain1 = makeChain(KVOAdapter(self.number1Field, keyPath: \.text),
                               UIControlAdapter(self.number1Field, events: .editingChanged))
        let chain2 = makeChain(KVOAdapter(self.number2Field, keyPath: \.text),
                               UIControlAdapter(self.number2Field, events: .editingChanged))
        let chain3 = makeChain(KVOAdapter(self.number3Field, keyPath: \.text),
                               UIControlAdapter(self.number3Field, events: .editingChanged))
        
        self.observer =
            chain1
                .combine(chain2)
                .combine(chain3)
                .map { String($0.0 + $0.1 + $0.2) }
                .sendTo(KVOAdapter(self.resultLabel, keyPath: \.text).retain())
                .sync()
    }
}
