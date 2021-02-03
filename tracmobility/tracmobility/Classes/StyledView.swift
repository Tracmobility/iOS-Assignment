//
//  StyledView.swift
//  ordering-enterprise-ios-app
//
//  Created by Ordering, Inc. on 6/5/18.
//  Copyright © 2018-2019 Ordering, Inc. All rights reserved.
//

import UIKit

@IBDesignable
class StyledView: UIView {
}

class StyledTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super .editingRect(forBounds: bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super .editingRect(forBounds: bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return super .editingRect(forBounds: bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)))
    }
}

@IBDesignable
class StyledButton: UIButton {
    
}

@IBDesignable
class StyledLabel: UILabel {
}

@IBDesignable
class StyledImage: UIImageView {
    override var intrinsicContentSize: CGSize {
        
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
}

extension UIView {
    
    func setShadow(blur: CGFloat = 2.0, x: CGFloat =  0, y: CGFloat = 0, alpa: Float = 0.5, color: CGColor = UIColor.darkGray.cgColor) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = color
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowRadius = blur
        layer.shadowOpacity = alpa
        layer.masksToBounds = false
    }
    
    @IBInspectable
    var isCircled : Bool {
        get  {
            return layer.cornerRadius == (layer.bounds.height - layer.borderWidth) * 0.5
        }
        set {
            layer.cornerRadius = (layer.bounds.height - layer.borderWidth) * 0.5
        }
    }
    
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
