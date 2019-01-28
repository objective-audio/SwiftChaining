//
//  RootViewController.swift
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSClassFromString("XCTestCase") == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "RootNavigation")
            self.present(viewController, animated: false, completion: nil)
        }
    }
}
