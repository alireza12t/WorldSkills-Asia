//
//  SplashViewController.swift
//  WSR-Asia
//
//  Created by ali on 8/3/21.
//

import UIKit

class SplashViewController: UIViewController, Storyboarded {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataManager.shared.token.isEmpty {
            let vc = LoginViewController.instantiate("Main")
            self.navigationController?.setViewControllers([vc], animated: true)
        } else {
            let vc = HomeViewController.instantiate("Main")
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }

}
