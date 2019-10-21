//
//  RegistrationViewController.swift
//  HERMONY
//
//  Created by Magdy rizk on 4/19/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var passwordFiled: UITextField!
    @IBOutlet weak var mobileNumberField: UITextField!
    @IBOutlet weak var emailFiled: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func RegistrationBtn(_ sender: Any) {
        self.view.lock()
        self.view.endEditing(true)
        DispatchQueue.main.async{
            self.view.lock()
            let parameters = ["phone": self.mobileNumberField.text!, "password": self.passwordFiled.text!,"name":"\(self.firstName.text!)\(self.lastNameField.text!)","email":self.emailFiled.text!,"address":"egypt-cario"]
            let api = BackendApi()
            print(parameters)
            api.perform(serviceName: ServiceName.registration, parameters: parameters as [String : AnyObject]?) { (JSON, String) -> Void in
                if String != nil{
                    self.view.unlock()
                    self.showAlertWithTitle("Alert".localized, message: String!)
                }
                else{
                    User.sharedInstance.getDateFromJSON(JSON!["userdata"])
                    User.sharedInstance.saveData()
                    
                    User.sharedInstance.setIsRegister(true)
                    print(User.sharedInstance.email)
                    print(User.sharedInstance.name)
                    print(User.sharedInstance.phone)
                        self.view.unlock()
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        delegate.setHomeViewAsRoot()
                        
                    }
                    
                }
            }
            
        }
    }
    

