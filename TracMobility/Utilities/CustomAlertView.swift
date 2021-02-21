//
//  CustomAlertView.swift
//  TracMobility
//
//  Created by Shalini on 20/02/21.
//

import UIKit

/// `AlertView Controller`
class CustomAlertView: UIAlertController {
    
    static let sharedInstance = CustomAlertView()
    
    //default alert with ok and cancel actions
    func defaultAlert(_ view: UIViewController,_ title: String?,_ message: String?,_ okText: String?,_ okStyle: UIAlertAction.Style,_ cancelText: String?,_ cancelStyle: UIAlertAction.Style, alertStyle preffered: UIAlertController.Style) {
        
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: preffered)
            let okAction = UIAlertAction(title: okText ?? "OK", style: okStyle, handler: nil)
            let cancelAction = UIAlertAction(title: cancelText ?? "Cancel", style: cancelStyle, handler: nil)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            view.present(alert, animated: true)
        })
    }
    
    //alert with ok action
    func okAlert(_ view: UIViewController,_ title: String?,_ message: String?,_ okText: String?,_ okStyle: UIAlertAction.Style, alertStyle preffered: UIAlertController.Style) {
        
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: preffered)
            let okAction = UIAlertAction(title: okText ?? "OK", style: okStyle, handler: nil)
            
            alert.addAction(okAction)
            view.present(alert, animated: true)
        })
    }
    
    //alert with timer
    func timerAlert(_ view: UIViewController,_ title: String?,_ message: String?,_ timer: DispatchTime, alertStyle preffered: UIAlertController.Style) {
        
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: preffered)
            
            view.present(alert, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: timer){
                alert.dismiss(animated: true, completion: nil)
            }
        })
    }
}

/// `Activity Indicator`
class CustomActivityIndicator: UIActivityIndicatorView {
    
    static var sharedInstance = CustomActivityIndicator()
    var activity = UIActivityIndicatorView()
    
    //present the activity indicator
    func presentActivityIndicator(_ viewController: UIViewController) {
        DispatchQueue.main.async {
            self.activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            self.activity.style = UIActivityIndicatorView.Style.large
            
            self.activity.center = viewController.view.center
            viewController.view.addSubview(self.activity)
            self.activity.startAnimating()
        }
    }
    
    //start animating
    func startAnimating(_ viewController: UIViewController) {
        DispatchQueue.main.async {
            self.activity.isHidden = false
            self.activity.startAnimating()
            
            //If the indicator is active, disable user interaction
            viewController.view.isUserInteractionEnabled = false
            if let leftNavigationItem = viewController.navigationItem.leftBarButtonItems {
                for (index, _) in leftNavigationItem.enumerated() {
                    viewController.navigationItem.leftBarButtonItems?[index].isEnabled = false
                }
            }
        }
    }
    
    //stop animating
    func stopAnimating(_ viewController: UIViewController) {
        DispatchQueue.main.async {
            self.activity.stopAnimating()
            self.activity.isHidden = true
            
            //If the indicator is inactive, enable user interaction
            viewController.view.isUserInteractionEnabled = true
            if let leftNavigationItem = viewController.navigationItem.leftBarButtonItems {
                for (index, _) in leftNavigationItem.enumerated() {
                    viewController.navigationItem.leftBarButtonItems?[index].isEnabled = true
                }
            }
            
        }
    }
}

