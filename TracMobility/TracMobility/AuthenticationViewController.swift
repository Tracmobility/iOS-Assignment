//
//  AuthenticationViewController.swift
//  TracMobility
//
//  Created by sabaz shereef on 05/02/21.
//

import UIKit
import Auth0

class AuthenticationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
            
    }
    
    @IBAction func authButton(_ sender: Any) {
        
        Authenticate()
        
    }
    
    func Authenticate()  {
        
        Auth0
            .webAuth()
            .scope("openid profile")
            .useEphemeralSession()
            .audience("https://dev-wwnonby5.eu.auth0.com/userinfo")
            .start { result in
                switch result {
                case .failure(let error):
                    
                    print("Error: \(error)")
                case .success(let credentials):
                    
                    print("Credentials: \(credentials)")
                    
                    let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
                    credentialsManager.store(credentials: credentials)
                    
                    let authViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                    
                    self.navigationController?.pushViewController(authViewController, animated: true)
                    
                }
            }
    }
}
