//
//  SuspendViewController.swift
//

import UIKit
import Chaining

class SuspendViewController: UIViewController {
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var suspendButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var arrowLabel: UILabel!
    @IBOutlet weak var suspendedLabel: UILabel!
    
    var resumeButtonEnabledAdapter: KVOAdapter<UIButton, Bool>!
    var suspendButtonEnabledAdapter: KVOAdapter<UIButton, Bool>!
    var labelTextAdapter: KVOAdapter<UILabel, String?>!
    var arrowLabelTextAdapter: KVOAdapter<UILabel, String?>!
    var suspendedLabelTextAdapter: KVOAdapter<UILabel, String?>!
    let holder = Holder<String>("0")
    var pool = ObserverPool()
    var suspender: AnySuspender!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resumeButtonEnabledAdapter = KVOAdapter(self.resumeButton, keyPath: \UIButton.isEnabled)
        self.suspendButtonEnabledAdapter = KVOAdapter(self.suspendButton, keyPath: \UIButton.isEnabled)
        self.labelTextAdapter = KVOAdapter(self.label, keyPath: \UILabel.text)
        self.arrowLabelTextAdapter = KVOAdapter(self.arrowLabel, keyPath: \UILabel.text)
        self.suspendedLabelTextAdapter = KVOAdapter(self.suspendedLabel, keyPath: \UILabel.text)
        
        self.pool += self.holder.chain().receive(self.labelTextAdapter).sync()
        
        let suspender = Suspender { [weak self] in
            guard let self = self else { return nil }
            return self.holder.chain().receive(self.suspendedLabelTextAdapter).sync()
        }
        
        self.pool += suspender.state.chain().to { $0 == .suspended }.receive(self.resumeButtonEnabledAdapter).sync()
        self.pool += suspender.state.chain().to { $0 == .resumed }.receive(self.suspendButtonEnabledAdapter).sync()
        
        self.pool += suspender.state.chain()
            .to { $0 == .resumed ? "↓" : "-" }
            .receive(self.arrowLabelTextAdapter)
            .sync()
        
        self.suspender = suspender
        self.suspender.resume()
    }
    
    @IBAction func resume() {
        self.suspender.resume()
    }
    
    @IBAction func suspend() {
        self.suspender.suspend()
    }
    
    @IBAction func setValue() {
        self.holder.value = String(Int.random(in: 0..<100))
    }
}
