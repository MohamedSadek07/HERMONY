//
//  CustomButton.swift
//  Taallam
//
//  Created by Eng. Eman Rezk on 4/30/17.
//  Copyright © 2017 Eng.Eman Rezk. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton {
    
//        @IBInspectable var borderColor:UIColor = UIColor.white
//        @IBInspectable var borderWidth:CGFloat = 0
//        @IBInspectable var cornerRadius:CGFloat = 0
    
    override func draw(_ rect: CGRect) {
                self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius =  cornerRadius
        self.layer.masksToBounds = true
        
        //        self.titleEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        self.contentEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
    }
}
