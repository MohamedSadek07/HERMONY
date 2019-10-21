//
//  UINavigationItemExtension.swift
//  Taallam
//
//  Created by Eng. Eman Rezk on 5/4/17.
//  Copyright © 2017 Eng.Eman Rezk. All rights reserved.
//

import UIKit

extension UINavigationItem {
    
    //Make the title 2 lines with a title and a subtitle
    func addTitleAndSubtitleToNavigationBar (_ title: String, subtitle: String) {
        
        let label = UILabel(frame: CGRect(x: 10.0, y: 0.0, width: 50.0, height: 40.0))
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.numberOfLines = 2
        
        
        label.attributedText = Utility.getAttributedString("Book number 1", SubTitle: "Eman", NewLineAfterText: true, FontSize: 17.0, SubTitleFontSize: 13.0, TitleColor: UIColor.white, SubTitleColor: UIColor.lightGray)
        
        //            label.text = "\(title)\n\(subtitle)"
        //            label.textColor = UIColor.black
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.center
        self.titleView = label
    }
}
