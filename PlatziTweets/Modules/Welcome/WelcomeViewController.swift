//
//  WelcomeViewController.swift
//  PlatziTweets
//
//  Created by Resonant Sports on 05/02/2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var registerButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

       setupUi()
    }
    

    private func setupUi() {
        loginButton.layer.cornerRadius = 25
    }

}
  
