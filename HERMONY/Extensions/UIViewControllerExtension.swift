//
//  UIViewControllerExtension.swift
//  Taallam
//
//  Created by Eng. Eman Rezk on 4/30/17.
//  Copyright © 2017 Eng.Eman Rezk. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @IBAction public func back(sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func showToastMessage(_ message: String, completionHandler completion:@escaping () -> Void){
        let toast = UIAlertController(title: nil, message: message,
                                      preferredStyle: .alert)
        
        let messageFont = [NSAttributedStringKey.font: UIFont(name: fontName, size: toastFont)!]
        
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        toast.setValue(messageAttrString, forKey: "attributedMessage")
        
        present(toast, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            toast.dismiss(animated: true, completion: {
                completion()
            })
        }
        
        
    }
    
    func showAlertWithSettingsUrl(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings".localized, style: .default) { (alertAction) in
            
            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(appSettings as URL)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func showAlertWithTitle(_ title: String, message: String) {
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles:  "OK".localized)
        
        // Configure Alert View
        alertView.tag = 1
        
        // Show Alert View
        alertView.show()
    }
    
    func isNotEmptyString(_ text: String, withAlertMessage message: String) -> Bool{
        if text == ""{
            showAlertWithTitle("Alert".localized, message: message)
            return false
        }
        else{
            return true
        }
    }
    
    func isEmailVaild(_ emailString: String) -> Bool{
        let regExPattern = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regExPattern])
        if !emailTest.evaluate(with: emailString){
            showAlertWithTitle("Alert".localized, message: "Please, Insert Email Correctly".localized)
        }
        return emailTest.evaluate(with: emailString)
    }
    
    func isPhoneNumberValid(_ phoneNumber: String) -> Bool{
        var isValid = true
        let nameValidation = phoneNumber.replacingOccurrences(of: " ", with: "")
        
        if (nameValidation.characters.count < 9 || nameValidation.characters.count > 14) { //check length limitation
            isValid = false
        }
        //        else{
        //            var numericSet = NSCharacterSet.decimalDigitCharacterSet()
        //            numericSet = numericSet.invertedSet
        //            if  phoneNumber.rangeOfCharacterFromSet(numericSet) != nil && numericSet != "+"{
        //                print("the phoneNumber contains illegal characters")
        //                isValid = false
        //            }
        //        }
        
        if !isValid{
            showAlertWithTitle("Alert".localized, message: "Please, Insert Phone Number Correctly".localized)
        }
        
        return isValid
    }
    
}
