//
//  SigninController.swift
//  tracmobility
//
//  Created by David K on 2/3/21.
//

import UIKit
import Auth0
import ProgressHUD
import GoogleSignIn

class SigninController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var emailField: StyledTextField!
    @IBOutlet weak var passwordField: StyledTextField!
    
    let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func OnSigninBtn(_ sender: Any) {
        if !emailField.text!.isValidEmail() {
            Utils.showAlert(title: nil, message: "Enter a valid email address", controller: self)
            return
        }
        
        if passwordField.text!.count < 6 && passwordField.text!.count > 18 {
            Utils.showAlert(title: nil, message: "Password must be 6-18 characters", controller: self)
            return
        }
        
        ProgressHUD.show("Please wait...")
        
        Auth0
            .authentication()
            .login(
                usernameOrEmail: emailField.text!,
                password: passwordField.text!,
                realm: "Username-Password-Authentication",
                scope: "openid")
             .start { result in
                
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                }
                
                 switch result {
                 case .success(let credentials):
                    print("Credentials: \(credentials)")
                    
                    _ = self.credentialsManager.store(credentials: credentials)
                    
                    
                    DispatchQueue.main.async {
                        self.getProfile(accessToken: credentials.accessToken!)
                    }
                    
                 case .failure(let error):
                    print("Failed with \(error)")
                    Utils.showAlert(title: "Error", message: error.localizedDescription, controller: self)
                 }
             }
        
    }
    
    func getProfile(accessToken: String) {
        Auth0
            .authentication()
            .userInfo(withAccessToken: accessToken)
            .start { result in
                switch(result) {
                case .success(let profile):
                    let defaults = UserDefaults.standard
                    defaults.set(profile.email ?? "", forKey: "email")
                    defaults.set(profile.customClaims!["username"] ?? "", forKey: "username")
                    
                    defaults.synchronize()
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "MainSegue", sender: self)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    @IBAction func OnFBSigninBtn(_ sender: Any) {
        Utils.showAlert(title: nil, message: "Coming soon", controller: self)
    }
    
    @IBAction func OnGoogleSigninBtn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error == nil {
            Auth0
                .authentication()
                .loginSocial(token: user.authentication.accessToken, connection : "google-oauth2", scope: "openid profile")
                .start { result in
                    switch result {
                    case .success(let credentials):
                       print("Credentials: \(credentials)")
                       
                    case .failure(let error):
                       print("Failed with \(error)")
                    }
                }
        }
    }
    
    @IBAction func OnSignupBtn(_ sender: Any) {
        var array: [UIViewController] = []
        array.append(navigationController!.viewControllers[0])
        array.append(navigationController!.viewControllers[1])
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let signinController = storyboard.instantiateViewController(identifier: "SignupController")
        array.append(signinController)
        navigationController?.setViewControllers(array, animated: true)
    }
    
    @IBAction func OnBackBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
