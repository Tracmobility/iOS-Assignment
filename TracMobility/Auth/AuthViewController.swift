//
//  AuthViewController.swift
//  TracMobility
//
//  Created by Sania Zafar on 16/02/2021.
//

import UIKit
import GoogleSignIn

class AuthViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    static let GoogleSignInCancelCode = -5
    
    
    // MARK: - View LifeCycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func tappedSignup(_ sender: Any) {
        self.isValidUserInfo() ? self.navigateToMaps() : self.showAlert(with: "Please Enter all Fields")
    }
    
    @IBAction func tappedGoogleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func tappedFacebookLogin(_ sender: Any) {
        //TODO
        self.showAlert(with: "We're sorry! Stay with us while we develop this feature")
    }
    
}


// MARK: - Private

private extension AuthViewController {
    
    func configureUI() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
    }
    
    func navigateToMaps() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
            mapViewController.modalPresentationStyle = .fullScreen
            self.present(mapViewController, animated: true, completion: nil)
        }
    }
    
    ///This method only checks for empty text fields, we can also add validation for Name and Email later
    func isValidUserInfo() -> Bool {
        
        return !(self.firstNameTextField.text?.isEmpty ?? true) &&
            !(self.lastNameTextField.text?.isEmpty ?? true) &&
            !(self.emailTextField.text?.isEmpty ?? true)
    }
    
    func showAlert(with message: String) {
        let alertController = UIAlertController(title: "Trac Mobility", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


// MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}


// MARK: - GIDSignInDelegate Methods

extension AuthViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let googleError = error as NSError?, googleError.code != AuthViewController.GoogleSignInCancelCode {
            
        } else if let googleError = error as NSError?,
                  googleError.code == AuthViewController.GoogleSignInCancelCode {
            
            return
        } else if user != nil, let _ = user.authentication {
            self.navigateToMaps()
        }
    }
    
}
