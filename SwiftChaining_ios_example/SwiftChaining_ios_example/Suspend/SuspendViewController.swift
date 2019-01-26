//
//  SuspendViewController.swift
//

import UIKit
import Chaining

class SuspendViewController: UIViewController {
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var suspendButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var resumeButtonEnabledAlias: KVOAdapter<UIButton, Bool>!
    var suspendButtonEnabledAlias: KVOAdapter<UIButton, Bool>!
    var labelTextAlias: KVOAdapter<UILabel, String?>!
    let holder = Holder<String>("-")
    var pool = ObserverPool()
    var suspender: AnySuspender!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resumeButtonEnabledAlias = KVOAdapter(self.resumeButton, keyPath: \UIButton.isEnabled)
        self.suspendButtonEnabledAlias = KVOAdapter(self.suspendButton, keyPath: \UIButton.isEnabled)
        self.labelTextAlias = KVOAdapter(self.label, keyPath: \UILabel.text)
        
        let suspender = Suspender { [weak self] in
            guard let self = self else { return nil }
            return self.holder.chain().receive(self.labelTextAlias).sync()
        }
        
        self.pool += suspender
        
        self.pool += suspender.state.chain().to({ $0 == .suspended }).receive(self.resumeButtonEnabledAlias).sync()
        self.pool += suspender.state.chain().to({ $0 == .resumed }).receive(self.suspendButtonEnabledAlias).sync()
        
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
