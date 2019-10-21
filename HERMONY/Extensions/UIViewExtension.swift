//
//  UIViewExtension.swift
//  Taallam
//
//  Created by Eng. Eman Rezk on 4/30/17.
//  Copyright © 2017 Eng.Eman Rezk. All rights reserved.
//

import UIKit


extension UIView {
    
    @IBInspectable var isCircle: Bool{
        set{
                
            if isCircle{
                self.layer.cornerRadius =  self.frame.size.height / 2
                self.layer.masksToBounds = true
            }
        }
        get{
           return self.isCircle
        }
    }
    
    @IBInspectable var borderWidth: CGFloat{
        get{
            return self.layer.borderWidth
        }
        set{
            self.layer.borderWidth = newValue
        }
    }
    
    
    @IBInspectable var borderColor: UIColor {
        get{
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    func addShadow(_ shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        //        self.backgroundColor = UIColor.clear
        //        layer.backgroundColor = UIColor.white.cgColor
        
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
    
    
    func removeNoDataLabel(_ tag: Int = 10000){
        if let noDataLabel = self.viewWithTag(tag) {
            UIView.animate(withDuration: 0.2, animations: {
                noDataLabel.alpha = 0.0
            }) { finished in
                noDataLabel.removeFromSuperview()
            }
        }
    }
    
    func setNoDataView(text: String = "No Data", frameRect: CGRect = CGRect.zero, withBackgroundColor backgroundColor: UIColor =  UIColor(white: 0.0, alpha: 0.2), textColor: UIColor = UIColor.gray ){
        
        print("self.frame:\(self.frame)")
        print("self.bounds:\(self.bounds)")
        print("self.center:\(self.center)")
        removeNoDataLabel()
        let containerView = UIView()
        let label = UILabel()
        
        if frameRect == CGRect.zero{
            containerView.frame = bounds
        }
        else{
            containerView.frame = frameRect
        }
        
        
        
        if containerView.frame.origin.x < 0{
            containerView.center = CGPoint(x: ((containerView.frame.width / 2) * -1), y: containerView.frame.height / 2)
        }
        
        
        containerView.tag = 10000
        containerView.backgroundColor = self.backgroundColor
        
        label.frame = containerView.bounds
        label.frame.origin.x = 10
        label.frame.size.width =  containerView.frame.size.width - 20
        //        label.center = containerView.center
        label.numberOfLines = 0
        label.backgroundColor = self.backgroundColor
        label.textAlignment = .center
        label.textColor = textColor
        label.text = text
        //        label.font = UIFont(name: fontName, size: fontSize)
        
        containerView.addSubview(label)
        
        addSubview(containerView)
    }
    
    
    func lock(_ frameRect: CGRect = CGRect.zero, indicatorColor: UIColor = UIColor.red) {
        if (viewWithTag(10) != nil) {
            //View is already locked
        }
        else {
            let lockView = UIView()
            
            if frameRect == CGRect.zero{
                lockView.frame = bounds
            }
            else{
                lockView.frame = frameRect
            }
            
            
            //            lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
            
            lockView.tag = 10
            lockView.alpha = 0.0
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            activity.color = indicatorColor
            
            activity.center = CGPoint(x: lockView.frame.width / 2, y:lockView.frame.height / 2)
            activity.hidesWhenStopped = true
            //            activity.center = lockView.center
            
            lockView.addSubview(activity)
            activity.startAnimating()
            addSubview(lockView)
            
            UIView.animate(withDuration: 0.2) {
                lockView.alpha = 1.0
            }
        }
    }
    
    func setActivityIndicator(){
        removeActivityIndicator()
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        activity.color = UIColor.white
        activity.tag = 50000
        activity.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        activity.hidesWhenStopped = true
        activity.center = self.center
        
        activity.startAnimating()
        addSubview(activity)
    }
    
    func removeActivityIndicator(){
        let activity = self.viewWithTag(50000) as? UIActivityIndicatorView
        //        activity.stopAnimating()
        activity?.removeFromSuperview()
    }
    
    
    func unlock() {
        if let lockView = self.viewWithTag(10) {
            UIView.animate(withDuration: 0.2, animations: {
                lockView.alpha = 0.0
            }) { finished in
                lockView.removeFromSuperview()
            }
        }
    }
}

