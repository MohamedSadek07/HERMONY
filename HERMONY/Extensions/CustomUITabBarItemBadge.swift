//
//  CustomUITabBarItemBadge.swift
//  Taallam
//
//  Created by Eng. Eman Rezk on 5/17/17.
//  Copyright © 2017 Eng.Eman Rezk. All rights reserved.
//

import UIKit


    private var handle: UInt8 = 0;
    
    extension UITabBarItem {
        fileprivate var badgeLayer: CAShapeLayer? {
            if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
                return b as? CAShapeLayer
            } else {
                return nil
            }
        }
        
        func addBadge(_ number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
            guard let view = self.value(forKey: "view") as? UIView else { return }
            
            badgeLayer?.removeFromSuperlayer()
            
//            var badgeWidth = 8
//            var numberOffset = 4
//            
//            if number > 9 {
//                badgeWidth = 12
//                numberOffset = 6
//            }
            
           
            // Initialize Badge
            let badge = CAShapeLayer()
            let radius = CGFloat(3)//CGFloat(7)
//            let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
            let location = CGPoint(x: (view.frame.width/2) + (radius + offset.x), y: (radius + offset.y))

            badge.drawCircleAtLocation(location, withRadius: radius, andColor: color, filled: filled)
            view.layer.addSublayer(badge)
            
            // Save Badge as UIBarButtonItem property
            objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        func updateBadge(_ number: Int) {
            if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
                text.string = "\(number)"
            }
        }
        
        func removeBadge() {
            badgeLayer?.removeFromSuperlayer()
        }
}

