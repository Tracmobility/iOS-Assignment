//
//  LaunchScreenViewController.swift
//  TracMobility
//
//  Created by Shalini on 20/02/21.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    @IBOutlet weak var tracMobilityLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        /// `Animate the launch screen`
        UIView.animate(withDuration: 0.4, delay: 0.8, options: [.curveEaseIn], animations: {
            
            let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
            rotation.toValue = NSNumber(value: Double.pi * 2)
            rotation.duration = 1.2
            rotation.repeatCount = 1
            self.tracMobilityLogo.layer.add(rotation, forKey: "rotationAnimation")
            
        }, completion: {_ in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) {
                
                if UserDefaults.standard.value(forKey: "accessToken") != nil {
                    
                    // redirect to dashboard if user already logged In
                    let storyboard = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "DashboardViewControllerID") as! DashboardViewController
                    storyboard.modalPresentationStyle = .fullScreen
                    self.present(storyboard, animated: true)
                    
                } else {
                    
                    // redirect the user to sign up screen
                    let storyboard = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "navigationControllerID") as! UINavigationController
                    storyboard.modalPresentationStyle = .fullScreen
                    self.present(storyboard, animated: true, completion:nil)
                }
            }
        })
    }
}
