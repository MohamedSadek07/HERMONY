//
//  ForgetPasswordViewController.swift
//  HERMONY
//
//  Created by Magdy rizk on 4/19/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var mobileNumberTXT: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func forgetBtn(_ sender: Any) {
        forget()
    }
    func forget(){
        self.view.lock()
        self.view.endEditing(true)
        DispatchQueue.main.async{
            self.view.lock()
            let parameters = ["phone": self.mobileNumberTXT.text!]
            let api = BackendApi()
            print(parameters)
            api.perform(serviceName: ServiceName.foroget_password, parameters: parameters as [String : AnyObject]?) { (JSON, String) -> Void in
                if String != nil{
                    self.view.unlock()
                    self.showAlertWithTitle("Alert".localized, message: String!)
                }
                else{
                    print(JSON)
                  
                    
                    
                    
                }
            }
            
        }
    }
}
