//
//  PrettyButton.swift
//  Flour Power 2.0
//
//  Created by Kelly Robinson on 8/4/16.
//  Copyright © 2016 Kelly Robinson. All rights reserved.
//
import UIKit

@IBDesignable

class PrettyButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    
    
    override func drawRect(rect: CGRect) {
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
        
    }
    
    @IBInspectable var borderWidth: CGFloat = 2
    
    @IBInspectable var borderColor: CGColor = UIColor.blackColor().CGColor
}
