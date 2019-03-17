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
    
    private let pool = ObserverPool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameValidLabel.text = "Username has to be at least 5 characters"
        self.passwordValidLabel.text = "Password has to be at least 5 characters"
        
        let makeValidChain = { (textAdapter: TextAdapter, changedAdapter: ChangedAdapter, hiddenAdapter: HiddenAdapter) in
            return changedAdapter
                .retain()
                .chain()
                .map { $0.text }
                .merge(textAdapter.retain().chain())
                .map { $0?.count ?? 0 >= 5 }
                .sendTo(hiddenAdapter.retain())
        }
        
        let usernameChain = makeValidChain(KVOAdapter(self.usernameField, keyPath: \.text),
                                           UIControlAdapter(self.usernameField, events: .editingChanged),
                                           KVOAdapter(self.usernameValidLabel, keyPath: \.isHidden))
        let passwordChain = makeValidChain(KVOAdapter(self.passwordField, keyPath: \.text),
                                           UIControlAdapter(self.passwordField, events: .editingChanged),
                                           KVOAdapter(self.passwordValidLabel, keyPath: \.isHidden))
        
        usernameChain
            .combine(passwordChain)
            .map { $0.0 && $0.1 }
            .sendTo(KVOAdapter(self.doSomethingButton, keyPath: \.isEnabled).retain())
            .sync()
            .addTo(self.pool)
        
        UIControlAdapter(self.doSomethingButton, events: .touchUpInside)
            .retain()
            .chain()
            .do { [weak self] _ in
                let alert = UIAlertController(title: "Chaining Example", message: "This is wonderful", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            .end()
            .addTo(self.pool)
    }
}
