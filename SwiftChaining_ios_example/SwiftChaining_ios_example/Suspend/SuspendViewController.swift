//
//  SuspendViewController.swift
//

import UIKit
import Chaining

class SuspendViewController: UIViewController {
    @IBOutlet weak var suspendButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var srcLabel: UILabel!
    @IBOutlet weak var arrowLabel: UILabel!
    @IBOutlet weak var dstLabel: UILabel!
    
    let suspender = Suspender()
    let srcNumber = ValueHolder(0)
    let dstNumber = ValueHolder(0)
    let pool = ObserverPool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.srcNumber.chain()
            .suspend(self.suspender)
            .sendTo(self.dstNumber)
            .sync()
            .addTo(self.pool)
        
        self.srcNumber.chain()
            .map { "\($0)" }
            .sendTo(KVOAdapter(self.srcLabel, keyPath: \.text).retain())
            .sync()
            .addTo(self.pool)
        
        self.dstNumber.chain()
            .map { "\($0)" }
            .sendTo(KVOAdapter(self.dstLabel, keyPath: \.text).retain())
            .sync()
            .addTo(self.pool)
        
        self.suspender.chain()
            .sendTo(KVOAdapter(self.resumeButton, keyPath: \.isEnabled).retain())
            .map { !$0 }
            .sendTo(KVOAdapter(self.suspendButton, keyPath: \.isEnabled).retain())
            .sync()
            .addTo(self.pool)
        
        self.suspender.chain()
            .map { $0 ? "-" : "↓" }
            .sendTo(KVOAdapter(self.arrowLabel, keyPath: \.text).retain())
            .sync()
            .addTo(self.pool)
        
        UIControlAdapter(self.suspendButton, events: .touchUpInside)
            .retain()
            .chain()
            .replace(true)
            .sendTo(self.suspender)
            .end()
            .addTo(self.pool)
        
        UIControlAdapter(self.resumeButton, events: .touchUpInside)
            .retain()
            .chain()
            .replace(false)
            .sendTo(self.suspender)
            .end()
            .addTo(self.pool)
        
        UIControlAdapter(self.randomButton, events: .touchUpInside)
            .retain()
            .chain()
            .map { _ in Int.random(in: 0..<100) }
            .sendTo(self.srcNumber)
            .end()
            .addTo(self.pool)
    }
    
}
