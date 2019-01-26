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

    private typealias TextAlias = KVOAdapter<UITextField, String?>
    private typealias ChangedAlias = UIControlAlias<UITextField>
    private typealias HiddenAlias = KVOAdapter<UILabel, Bool>
    
    private var usernameTextAlias: TextAlias!
    private var passwordTextAlias: TextAlias!
    private var usernameChangedAlias: ChangedAlias!
    private var passwordChangedAlias: ChangedAlias!
    private var usernameHiddenAlias: HiddenAlias!
    private var passwordHiddenAlias: HiddenAlias!
    private var buttonEnabledAlias: KVOAdapter<UIButton, Bool>!
    private var buttonTappedAlias: UIControlAlias<UIButton>!
    
    private var observer = ObserverPool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameValidLabel.text = "Username has to be at least 5 characters"
        self.passwordValidLabel.text = "Password has to be at least 5 characters"

        self.usernameTextAlias = KVOAdapter(self.usernameField, keyPath: \UITextField.text)
        self.passwordTextAlias = KVOAdapter(self.passwordField, keyPath: \UITextField.text)
        self.usernameChangedAlias = UIControlAlias(self.usernameField, events: .editingChanged)
        self.passwordChangedAlias = UIControlAlias(self.passwordField, events: .editingChanged)
        self.usernameHiddenAlias = KVOAdapter(self.usernameValidLabel, keyPath: \UILabel.isHidden)
        self.passwordHiddenAlias = KVOAdapter(self.passwordValidLabel, keyPath: \UILabel.isHidden)
        self.buttonEnabledAlias = KVOAdapter(self.doSomethingButton, keyPath: \UIButton.isEnabled)
        self.buttonTappedAlias = UIControlAlias(self.doSomethingButton, events: .touchUpInside)
        
        let makeValidChain = { (textAlias: TextAlias, changedAlias: ChangedAlias, hiddenAlias: HiddenAlias) in
            return changedAlias
                .chain()
                .to { $0.text }
                .merge(textAlias.chain())
                .to { $0?.count ?? 0 >= 5 }
                .receive(hiddenAlias)
        }
        
        let usernameChain = makeValidChain(self.usernameTextAlias, self.usernameChangedAlias, self.usernameHiddenAlias)
        let passwordChain = makeValidChain(self.passwordTextAlias, self.passwordChangedAlias, self.passwordHiddenAlias)
        
        self.observer += usernameChain.combine(passwordChain).to { $0.0 && $0.1 }.receive(buttonEnabledAlias).sync()
        
        self.observer +=
            self.buttonTappedAlias
                .chain()
                .do { [weak self] _ in
                    let alert = UIAlertController(title: "Chaining Example", message: "This is wonderful", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
                .end()
    }
}
