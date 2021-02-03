//
//  Utils.swift
//  tracmobility
//
//  Created by David K on 2/3/21.
//

import Foundation
import UIKit

class Utils {
    
    static func showAlert(title: String?, message: String, controller: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            controller.present(alert, animated: true, completion: nil)
        }
    }
}
