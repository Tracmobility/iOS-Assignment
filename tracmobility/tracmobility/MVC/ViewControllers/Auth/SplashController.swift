//
//  ViewController.swift
//  tracmobility
//
//  Created by David K on 2/3/21.
//

import UIKit
import Auth0

class SplashController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    
    let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationAnddelayOneSecond()
    }
    
    func animationAnddelayOneSecond() {
        // make the square not visible and scale it to 0.5x
        logoImage.alpha = 0
        logoImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        // Finally the animation!
        UIView.animate(
            withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.logoImage.transform = .identity
                self.logoImage.alpha = 1
                
            }, completion: {_ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                    self.checkLogin()
                }
            })
    }
    
    func checkLogin() {
        guard credentialsManager.hasValid() else {
            goAuth()
            return
            // No valid credentials exist, present the login page
        }
        
        credentialsManager.credentials { error, credentials in
            guard error == nil, let credentials = credentials else {
                self.goAuth()
                return
            }
            
            self.goMain()
            
            guard let accessToken = credentials.accessToken else {
                self.goAuth()
                return
            }
            
            Auth0
                .authentication()
                .userInfo(withAccessToken: accessToken)
                .start { result in
                    switch(result) {
                    case .success(let profile):
                        let defaults = UserDefaults.standard
                        defaults.set(profile.email ?? "", forKey: "email")
                        defaults.set(profile.nickname ?? "", forKey: "username")
                        defaults.synchronize()
                        
                        DispatchQueue.main.async {
                            self.goMain()
                        }
                        // You've got the user's profile, good time to store it locally.
                        // e.g. self.profile = profile
                    case .failure(let error):
                        print("Error: \(error)")
                        DispatchQueue.main.async {
                            self.goAuth()
                        }
                    }
                }
        }
    }
    
    func goAuth() {
        self.performSegue(withIdentifier: "AuthSegue", sender: self)
    }
    
    func goMain() {
        self.performSegue(withIdentifier: "MainSegue", sender: self)
    }
    
    @IBAction func logoutUser( _ seg: UIStoryboardSegue) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            self.goAuth()
        }
        
    }
}

