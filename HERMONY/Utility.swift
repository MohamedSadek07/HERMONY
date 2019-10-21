
//
//  Utility.swift
//  Taallam
//
//  Created by Eng. Eman Rezk on 5/4/17.
//  Copyright © 2017 Eng.Eman Rezk. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    class func getAttributedString(_ title: String, SubTitle subTitle: String, NewLineAfterText isNewLine: Bool = false, FontSize fontSize: CGFloat = 14.0, SubTitleFontSize subTitleFontSize: CGFloat = 12.0, TitleColor titleColor: UIColor, SubTitleColor subTitleColor: UIColor) -> NSAttributedString{
        
        var attributedString = NSMutableAttributedString()
        
        var string = title
        if isNewLine{
            string += "\n"
        }
        
        string += subTitle
        
        attributedString = NSMutableAttributedString(
            string: string)
        
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                      value: titleColor,
                                      range: NSRange(
                                        location:0,
                                        length:title.characters.count))
        
        attributedString.addAttribute(NSAttributedStringKey.font,
                                      value: UIFont(
                                        name: fontName,
                                        size: fontSize)!,
                                      range: NSRange(
                                        location:0,
                                        length:title.characters.count))
        
        attributedString.addAttribute(NSAttributedStringKey.font,
                                      value: UIFont(
                                        name: fontName,
                                        size: subTitleFontSize)!,
                                      range: NSRange(
                                        location:title.characters.count,
                                        length:string.characters.count - title.characters.count))
        
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                      value: subTitleColor,
                                      range: NSRange(
                                        location:title.characters.count,
                                        length:string.characters.count - title.characters.count))
        
        return attributedString
    }
    
}
