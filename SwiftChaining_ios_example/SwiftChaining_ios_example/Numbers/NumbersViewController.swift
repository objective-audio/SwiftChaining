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
    
    private typealias TextAlias = KVOAdapter<UITextField, String?>
    private typealias ChangedAlias = UIControlAdapter<UITextField>
    
    private var textAlias1: TextAlias!
    private var textAlias2: TextAlias!
    private var textAlias3: TextAlias!
    private var changedAlias1: ChangedAlias!
    private var changedAlias2: ChangedAlias!
    private var changedAlias3: ChangedAlias!
    private var resultAlias: KVOAdapter<UILabel, String?>!
    private var observer: AnyObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textAlias1 = KVOAdapter(self.number1Field, keyPath: \UITextField.text)
        self.textAlias2 = KVOAdapter(self.number2Field, keyPath: \UITextField.text)
        self.textAlias3 = KVOAdapter(self.number3Field, keyPath: \UITextField.text)
        self.changedAlias1 = UIControlAdapter(self.number1Field, events: .editingChanged)
        self.changedAlias2 = UIControlAdapter(self.number2Field, events: .editingChanged)
        self.changedAlias3 = UIControlAdapter(self.number3Field, events: .editingChanged)
        self.resultAlias = KVOAdapter(self.resultLabel, keyPath: \UILabel.text)
        
        let makeChain = { (textAlias: TextAlias, changedAlias: ChangedAlias) in
            return changedAlias.chain().to { $0.text }.merge(textAlias.chain()).to { string in Int(string ?? "") ?? 0 }
        }
        
        let chain1 = makeChain(self.textAlias1, self.changedAlias1)
        let chain2 = makeChain(self.textAlias2, self.changedAlias2)
        let chain3 = makeChain(self.textAlias3, self.changedAlias3)
        
        self.observer =
            chain1
                .combine(chain2)
                .to { $0.0 + $0.1 }
                .combine(chain3)
                .to { String($0.0 + $0.1) }
                .receive(self.resultAlias)
                .sync()
    }
}
