//
//  CircleView.swift
//  Meaad
//
//  Created by Eng. Eman Rezk on 7/20/16.
//  Copyright © 2016 Eng.Eman Rezk. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CircleView: UIView {
    
//        @IBInspectable var borderColor:UIColor = UIColor.white
//        @IBInspectable var borderWidth:CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius =  rect.height / 2
        self.layer.masksToBounds = true
    }
}

