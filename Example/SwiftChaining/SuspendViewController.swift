//
//  SuspendViewController.swift
//

import UIKit
import Chaining

class SuspendViewController: UIViewController {
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var suspendButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var resumeButtonEnabledAlias: KVOAlias<UIButton, Bool>!
    var suspendButtonEnabledAlias: KVOAlias<UIButton, Bool>!
    var labelTextAlias: KVOAlias<UILabel, String?>!
    let holder = Holder("")
    var pool = ObserverPool()
    var suspender: AnySuspender!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resumeButtonEnabledAlias = KVOAlias(object: self.resumeButton, keyPath: \UIButton.isEnabled)
        self.suspendButtonEnabledAlias = KVOAlias(object: self.suspendButton, keyPath: \UIButton.isEnabled)
        self.labelTextAlias = KVOAlias(object: self.label, keyPath: \UILabel.text)
        
        let suspender = Suspender(self) { viewController in
            return viewController.holder.chain().to { $0 }.receive(viewController.labelTextAlias).sync()
        }
        
        self.pool += suspender
        
        self.pool += suspender.state.chain().to({ state -> Bool in
            switch state {
            case .suspended:
                return true
            default:
                return false
            }
        }).receive(self.resumeButtonEnabledAlias).sync()
        
        self.pool += suspender.state.chain().to({ state -> Bool in
            switch state {
            case .resumed:
                return true
            default:
                return false
            }
        }).receive(self.suspendButtonEnabledAlias).sync()
        
        self.suspender = suspender
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.suspender.resume()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.suspender.suspend()
        
        super.viewDidDisappear(animated)
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
