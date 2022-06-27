//
//  LoginViewController.swift
//  PlatziTweets
//
//  Created by Resonant Sports on 05/02/2021.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class LoginViewController: UIViewController {
    
    private let emailKey = "email"
    
    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var emailField:UITextField!
    @IBOutlet weak var passField:UITextField!
    
    @IBAction func loginButtonAction() {
        view.endEditing(true)
        performLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUi()
    }
    
    private func setupUi() {
        loginButton.layer.cornerRadius = 25
        
        if let savedEmail = UserDefaults.standard.string(forKey: emailKey)  {
            emailField.text = savedEmail
        }
    }
    
    //User: martin@bordeline.com.ar Pass: robotics
    
    private func performLogin() {
        
        guard let email = emailField.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar un correo.", style: .warning).show()
            return
        }
        
        guard let pass = passField.text, !pass.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar un password.", style: .warning).show()
            return
        }
        
        let request = LoginRequest(email: email, password: pass)
        
        SVProgressHUD.show()
        
        SN.post(endpoint: Endpoints.login, model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            
            switch response {
                case .success(let user):
                    UserDefaults.standard.setValue(self.emailField.text, forKey: self.emailKey)
                    self.performSegue(withIdentifier: "showHome", sender: nil)
                    SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
                
                case .errorResult(let entity):
                    NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
                    
                case .error(let error):
                    NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
            }
        }
                    
    }
  
}
