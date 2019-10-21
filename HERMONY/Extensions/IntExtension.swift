//
//  IntExtension.swift
//  Taallam
//
//  Created by Eng. Eman Rezk on 5/15/17.
//  Copyright © 2017 Eng.Eman Rezk. All rights reserved.
//

import UIKit

extension Int {

    func toArabic()->String{
        let number = NSNumber(value: self)
        let format = NumberFormatter()
        format.locale = Locale(identifier: "ar_EG")
        let faNumber = format.string(from: number)
        
        return faNumber!
    }
}
