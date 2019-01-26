//
//  ViewController.swift
//

import UIKit
import Chaining

class ChainViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var buttonAdapter: UIControlAdapter<UIButton>!
    let didEnterBackgroundAdapter = NotificationAdapter(UIApplication.didEnterBackgroundNotification)
    let willEnterForegroundAdapter = NotificationAdapter(UIApplication.willEnterForegroundNotification)
    var labelTextAdapter: KVOAdapter<UILabel, String?>!
    var textFieldAdapter: KVOAdapter<UITextField, String?>!
    var pool = ObserverPool()
    
    let labelText = Holder<String>("launched")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonAdapter = UIControlAdapter(self.button, events: .touchUpInside)
        self.labelTextAdapter = KVOAdapter(self.label, keyPath: \UILabel.text)
        self.textFieldAdapter = KVOAdapter(self.textField, keyPath: \UITextField.text)
        
        self.pool += self.buttonAdapter.chain().to { _ in String(Int.random(in: 0..<100)) }.receive(self.labelText).end()
        self.pool += self.labelText.chain().receive(self.labelTextAdapter).sync()
        self.pool += self.labelText.chain().receive(self.textFieldAdapter).sync()
        self.pool += self.textFieldAdapter.chain().to { $0 ?? "nil" }.receive(self.labelText).sync()
        
        self.pool += self.didEnterBackgroundAdapter.chain().do { value in print("didEnterBackground \(value)")}.end()
        self.pool += self.willEnterForegroundAdapter.chain().do { value in print("willEnterForeground \(value)")}.end()
    }
}

extension ChainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

