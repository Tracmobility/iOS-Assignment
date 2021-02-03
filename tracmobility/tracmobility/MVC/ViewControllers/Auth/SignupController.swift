//
//  SignupController.swift
//  tracmobility
//
//  Created by David K on 2/3/21.
//

import UIKit
import Auth0
import ProgressHUD


class SignupController: UIViewController {

    @IBOutlet weak var nameField: StyledTextField!
    @IBOutlet weak var emailField: StyledTextField!
    @IBOutlet weak var passwordField: StyledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func OnSignupBtn(_ sender: Any) {
        
        if nameField.text!.count <= 1 {
            Utils.showAlert(title: nil, message: "Enter a valid name", controller: self)
            return
        }
        
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
            .createUser(
                email: emailField.text!,
                password: passwordField.text!,
                connection: "Username-Password-Authentication",
                userMetadata: ["username": nameField.text!])
            .start { result in
                
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                }
                
                switch result {
                case .success(let user):
                    print("User: \(user)")
                    Utils.showAlert(title: "Verify your email", message: "We've sent verification email. Please verify your email.", controller: self)
                    
                case .failure(let error):
                    print("Failed with \(error)")
                    Utils.showAlert(title: "Error", message: error.localizedDescription, controller: self)
                }
            }
    }
    
    @IBAction func OnSinginBtn(_ sender: Any) {
        var array: [UIViewController] = []
        array.append(navigationController!.viewControllers[0])
        array.append(navigationController!.viewControllers[1])
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let signinController = storyboard.instantiateViewController(identifier: "SigninController")
        array.append(signinController)
        navigationController?.setViewControllers(array, animated: true)
    }
    
    @IBAction func OnBackBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
