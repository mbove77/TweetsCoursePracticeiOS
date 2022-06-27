//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by Resonant Sports on 05/02/2021.
//

import UIKit
import NotificationBannerSwift
import SVProgressHUD
import Simple_Networking


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var createAccountButton:UIButton!
    @IBOutlet weak var nombreField:UITextField!
    @IBOutlet weak var emailField:UITextField!
    @IBOutlet weak var passField:UITextField!

    
    @IBAction func registerButtonAction() {
        view.endEditing(true)
        performRegister()
    }
    
    private func performRegister() {
        guard let name = nombreField.text, !name.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar tu Nombre y Apellido.", style: .warning).show()
            return
        }
        
        guard let email = emailField.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar un correo.", style: .warning).show()
            return
        }
        
        guard let pass = passField.text, !pass.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar un password.", style: .warning).show()
            return
        }
        
        let request = RegisterRequest(email: email, password: pass, names: name)
        
        SVProgressHUD.show()
        
        SN.post(endpoint: Endpoints.register, model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            
            switch response {
            case .success(let user):
                self.performSegue(withIdentifier: "showHome", sender: nil)
                SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
                
                case .errorResult(let entity):
                    NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
                    
                case .error(let error):
                    NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUi()
    }
    
    private func setupUi() {
        createAccountButton.layer.cornerRadius = 25
    }

}
