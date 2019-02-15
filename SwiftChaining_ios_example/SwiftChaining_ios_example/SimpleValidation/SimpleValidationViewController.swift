//
//  SimpleValidationViewController.swift
//

import UIKit
import Chaining

class SimpleValidationViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameValidLabel: UILabel!
    @IBOutlet weak var passwordValidLabel: UILabel!
    @IBOutlet weak var doSomethingButton: UIButton!

    private typealias TextAdapter = KVOAdapter<UITextField, String?>
    private typealias ChangedAdapter = UIControlAdapter<UITextField>
    private typealias HiddenAdapter = KVOAdapter<UILabel, Bool>
    
    private var usernameTextAdapter: TextAdapter!
    private var passwordTextAdapter: TextAdapter!
    private var usernameChangedAdapter: ChangedAdapter!
    private var passwordChangedAdapter: ChangedAdapter!
    private var usernameHiddenAdapter: HiddenAdapter!
    private var passwordHiddenAdapter: HiddenAdapter!
    private var buttonEnabledAdapter: KVOAdapter<UIButton, Bool>!
    private var buttonTappedAdapter: UIControlAdapter<UIButton>!
    
    private var observer = ObserverPool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameValidLabel.text = "Username has to be at least 5 characters"
        self.passwordValidLabel.text = "Password has to be at least 5 characters"

        self.usernameTextAdapter = KVOAdapter(self.usernameField, keyPath: \UITextField.text)
        self.passwordTextAdapter = KVOAdapter(self.passwordField, keyPath: \UITextField.text)
        self.usernameChangedAdapter = UIControlAdapter(self.usernameField, events: .editingChanged)
        self.passwordChangedAdapter = UIControlAdapter(self.passwordField, events: .editingChanged)
        self.usernameHiddenAdapter = KVOAdapter(self.usernameValidLabel, keyPath: \UILabel.isHidden)
        self.passwordHiddenAdapter = KVOAdapter(self.passwordValidLabel, keyPath: \UILabel.isHidden)
        self.buttonEnabledAdapter = KVOAdapter(self.doSomethingButton, keyPath: \UIButton.isEnabled)
        self.buttonTappedAdapter = UIControlAdapter(self.doSomethingButton, events: .touchUpInside)
        
        let makeValidChain = { (textAdapter: TextAdapter, changedAdapter: ChangedAdapter, hiddenAdapter: HiddenAdapter) in
            return changedAdapter
                .chain()
                .to { $0.text }
                .merge(textAdapter.chain())
                .to { $0?.count ?? 0 >= 5 }
                .sendTo(hiddenAdapter)
        }
        
        let usernameChain = makeValidChain(self.usernameTextAdapter, self.usernameChangedAdapter, self.usernameHiddenAdapter)
        let passwordChain = makeValidChain(self.passwordTextAdapter, self.passwordChangedAdapter, self.passwordHiddenAdapter)
        
        self.observer += usernameChain.combine(passwordChain).to { $0.0 && $0.1 }.sendTo(buttonEnabledAdapter).sync()
        
        self.observer +=
            self.buttonTappedAdapter
                .chain()
                .do { [weak self] _ in
                    let alert = UIAlertController(title: "Chaining Example", message: "This is wonderful", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
                .end()
    }
}
