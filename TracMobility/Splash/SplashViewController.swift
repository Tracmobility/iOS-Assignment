//
//  SplashViewController.swift
//  TracMobility
//
//  Created by sania zafar on 17/02/2021.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    // MARK: - View LifeCycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut) { [weak self] in
            self?.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { [weak self] (completed) in
            UIView.animate(withDuration: 1.0) {
                self?.logoImageView.transform = .identity
                self?.perform(#selector(self?.navigateToAuthScreen), with: nil, afterDelay: 1.0)
            }
        }
    }
    
    
    // MARK: - Private
    
    @objc private func navigateToAuthScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController {
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true, completion: nil)
        }
    }
    
}
