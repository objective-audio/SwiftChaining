//
//  ViewController.swift
//

import UIKit
import Chaining

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var buttonAlias: UIControlAlias!
    let didEnterBackgroundAlias = NotificationAlias(Notification.Name.UIApplicationDidEnterBackground)
    let willEnterForegroundAlias = NotificationAlias(Notification.Name.UIApplicationWillEnterForeground)
    var labelTextAlias: KVOAlias<UILabel, String?>!
    var textFieldAlias: KVOAlias<UITextField, String?>!
    var pool = ObserverPool()
    
    let labelText = Holder<String>("launched")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonAlias = UIControlAlias(self.button, events: .touchUpInside)
        self.labelTextAlias = KVOAlias(object: self.label, keyPath: \UILabel.text)
        self.textFieldAlias = KVOAlias(object: self.textField, keyPath: \UITextField.text)
        
        self.pool += self.buttonAlias.chain().do({ [weak self] _ in
            self?.labelText.value = String(arc4random() % 100)
        }).end()
        
        self.pool += self.labelText.chain().to { String?($0) }.receive(self.labelTextAlias).sync()
        self.pool += self.labelText.chain().to { String?($0) }.receive(self.textFieldAlias).sync()
        self.pool += self.textFieldAlias.chain().to { $0 ?? "nil" }.receive(self.labelText).sync()
        
        self.pool += self.didEnterBackgroundAlias.chain().do { value in print("didEnterBackground \(value)")}.end()
        self.pool += self.willEnterForegroundAlias.chain().do { value in print("willEnterForeground \(value)")}.end()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

