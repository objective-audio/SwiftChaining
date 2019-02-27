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
    
    private lazy var textAdapter1 = { KVOAdapter(self.number1Field, keyPath: \.text) }()
    private lazy var textAdapter2 = { KVOAdapter(self.number2Field, keyPath: \.text) }()
    private lazy var textAdapter3 = { KVOAdapter(self.number3Field, keyPath: \.text) }()
    private lazy var changedAdapter1 = { UIControlAdapter(self.number1Field, events: .editingChanged) }()
    private lazy var changedAdapter2 = { UIControlAdapter(self.number2Field, events: .editingChanged) }()
    private lazy var changedAdapter3 = { UIControlAdapter(self.number3Field, events: .editingChanged) }()
    private lazy var resultAdapter = { KVOAdapter(self.resultLabel, keyPath: \.text) }()
    private var observer: AnyObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let makeChain = { (textAdapter: TextAdapter, changedAdapter: ChangedAdapter) in
            return changedAdapter.chain().map { $0.text }.merge(textAdapter.chain()).map { string in Int(string ?? "") ?? 0 }
        }
        
        let chain1 = makeChain(self.textAdapter1, self.changedAdapter1)
        let chain2 = makeChain(self.textAdapter2, self.changedAdapter2)
        let chain3 = makeChain(self.textAdapter3, self.changedAdapter3)
        
        self.observer =
            chain1
                .combine(chain2)
                .combine(chain3)
                .map { String($0.0 + $0.1 + $0.2) }
                .sendTo(self.resultAdapter)
                .sync()
    }
}
