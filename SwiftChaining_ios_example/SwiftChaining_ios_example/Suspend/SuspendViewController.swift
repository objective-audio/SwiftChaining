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
    
    lazy var suspendEnabledAdapter = { KVOAdapter(self.suspendButton, keyPath: \.isEnabled) }()
    lazy var resumeEnabledAdapter = { KVOAdapter(self.resumeButton, keyPath: \.isEnabled) }()
    lazy var srcTextAdapter = { KVOAdapter(self.srcLabel, keyPath: \.text) }()
    lazy var arrowTextAdapter = { KVOAdapter(self.arrowLabel, keyPath: \.text) }()
    lazy var dstTextAdapter = { KVOAdapter(self.dstLabel, keyPath: \.text) }()
    
    let suspender = Suspender()
    let srcNumber = ValueHolder(0)
    let dstNumber = ValueHolder(0)
    let pool = ObserverPool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.srcNumber.chain().suspend(self.suspender).sendTo(self.dstNumber).sync().addTo(self.pool)
        self.srcNumber.chain().map { "\($0)" }.sendTo(self.srcTextAdapter).sync().addTo(self.pool)
        self.dstNumber.chain().map { "\($0)" }.sendTo(self.dstTextAdapter).sync().addTo(self.pool)
        self.suspender.chain().sendTo(self.resumeEnabledAdapter).map { !$0 }.sendTo(self.suspendEnabledAdapter).sync().addTo(self.pool)
        self.suspender.chain().map { $0 ? "-" : "↓" }.sendTo(self.arrowTextAdapter).sync().addTo(self.pool)
        
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
