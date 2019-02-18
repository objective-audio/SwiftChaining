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
    
    private var textAdapter1: TextAdapter!
    private var textAdapter2: TextAdapter!
    private var textAdapter3: TextAdapter!
    private var changedAdapter1: ChangedAdapter!
    private var changedAdapter2: ChangedAdapter!
    private var changedAdapter3: ChangedAdapter!
    private var resultAdapter: KVOAdapter<UILabel, String?>!
    private var observer: AnyObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textAdapter1 = KVOAdapter(self.number1Field, keyPath: \UITextField.text)
        self.textAdapter2 = KVOAdapter(self.number2Field, keyPath: \UITextField.text)
        self.textAdapter3 = KVOAdapter(self.number3Field, keyPath: \UITextField.text)
        self.changedAdapter1 = UIControlAdapter(self.number1Field, events: .editingChanged)
        self.changedAdapter2 = UIControlAdapter(self.number2Field, events: .editingChanged)
        self.changedAdapter3 = UIControlAdapter(self.number3Field, events: .editingChanged)
        self.resultAdapter = KVOAdapter(self.resultLabel, keyPath: \UILabel.text)
        
        let makeChain = { (textAdapter: TextAdapter, changedAdapter: ChangedAdapter) in
            return changedAdapter.chain().map { $0.text }.merge(textAdapter.chain()).map { string in Int(string ?? "") ?? 0 }
        }
        
        let chain1 = makeChain(self.textAdapter1, self.changedAdapter1)
        let chain2 = makeChain(self.textAdapter2, self.changedAdapter2)
        let chain3 = makeChain(self.textAdapter3, self.changedAdapter3)
        
        self.observer =
            chain1
                .combine(chain2, chain3)
                .map { String($0.0 + $0.1 + $0.2) }
                .sendTo(self.resultAdapter)
                .sync()
    }
}
