//
//  Extensions.swift
//  TracMobility
//
//  Created by Shalini on 20/02/21.
//

import UIKit
import SystemConfiguration
import CoreLocation

/// `String`
extension String {
    
    //remove blankSpaces
    func removingBlankSpaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

/// `Button`
extension UIButton {
    
    open override var isEnabled: Bool{
        didSet {
            DispatchQueue.main.async {
                self.alpha = self.isEnabled ? 1.0 : 0.6
            }
        }
    }
}

/// `View`
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

/// `TextField`
extension UITextField{
    func setBorderColor(_ width:CGFloat,_ color:UIColor,_ cornerRadius: CGFloat) -> Void{
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = cornerRadius
    }
}

//MARK: ------------------------ Enum ---------------------

/// `Sign In`
enum SignInType: String {
    
    case Apple = "Apple"
    case Google = "Google"
    case FaceBook = "Facebook"
    case SignUp = "SignUp"
}

/// `Menu Items`
enum Menu: String {
    
    case Rides = "Your Rides"
    case Wallet = "Wallet"
    case Membership = "Membership"
    case FreeRides = "Get Free Rides"
    case ReferAndEarn = "Refer & Earn"
    case Settings = "Settings"
    case Logout = "Logout"
    case Version = "Version 1.0"
}

//MARK: ------------------------ Class ---------------------

// Internet Connection
open class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
}
