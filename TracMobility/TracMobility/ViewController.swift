//
//  ViewController.swift
//  TracMobility
//
//  Created by sabaz shereef on 05/02/21.
//

import UIKit

class ViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let appLogo = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 150))
        
        appLogo.image = UIImage(named: "App Logo")
        appLogo.contentMode = .scaleAspectFit
        return appLogo
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        self.animation()
        
    }
    
    private func animation(){
        
        UIView.animate(withDuration: 1.5) {
            let imageSize = self.view.frame.size.width * 3
            let xPosition = imageSize - self.view.frame.size.width
            let yPosition  =  self.view.frame.size.height - imageSize
            self.imageView.frame = CGRect(
                x: -(xPosition/2),
                y: yPosition/2,
                width: imageSize,
                height: imageSize
            )
            
        }
        UIView.animate(withDuration: 1.5, animations:  {
            self.imageView.alpha = 0
        }) { (finished) in
            if finished{
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    let authViewController = self.storyboard?.instantiateViewController(withIdentifier: "Authentication") as! AuthenticationViewController
                    self.navigationController?.pushViewController(authViewController, animated: true)
                }
                
            }
        }
        
    }
    
}


