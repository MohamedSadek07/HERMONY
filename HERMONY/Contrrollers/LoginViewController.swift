//
//  LoginViewController.swift
//  HERMONY
//
//  Created by Magdy rizk on 4/19/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var PhoneNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func LoginBtn(_ sender: Any) {
        logIn()
    }
    func logIn(){
          self.view.lock()
        self.view.endEditing(true)
        DispatchQueue.main.async{
            self.view.lock()
            let parameters = ["phone": "01117878268", "password": "123456"] //["phone": self.PhoneNumber.text!, "password": self.Password.text!]
            
            let api = BackendApi()
            print(parameters)
            api.perform(serviceName: ServiceName.login, parameters: parameters as [String : AnyObject]?) { (JSON, String) -> Void in
                if String != nil{
                     self.view.unlock()
                    self.showAlertWithTitle("Alert".localized, message: String!)
                }
                else{
                    print(JSON)
                    User.sharedInstance.getDateFromJSON(JSON!["userdata"])
                    User.sharedInstance.saveData()
                    
                    User.sharedInstance.setIsRegister(true)
                    print(User.sharedInstance.email)
                    print(User.sharedInstance.name)
                    print(User.sharedInstance.phone)
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        delegate.setHomeViewAsRoot()
                    
                    

                    }
                }
            
            }
        }
    

    

}
