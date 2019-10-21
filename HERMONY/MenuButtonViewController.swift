//
//  MenuButtonViewController.swift
//  HERMONY
//
//  Created by Mohamed Ahmed Sadek on 5/3/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit

class MenuButtonViewController: UIViewController {
    @IBOutlet weak var userImge: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        print(User.sharedInstance.img)
        if User.sharedInstance.img == " "{
            let urlString = "aqary.elroily.com/Upload/user/\(User.sharedInstance.img)"
            
            print("IMAGE URL" , urlString)
            let url = URL(string : urlString)
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    print(url)
                    self.userImge.kf.indicatorType = .activity
                    self.userImge.kf.setImage(with: url)
                }
            }
        }else{
            
            self.userImge.image = UIImage(named: "pic profile")
        }
        
    }
    @IBAction func myAdsBtn(_ sender: Any) {
        performSegue(withIdentifier: "myAdsseg", sender: nil)
    }
    
    
    @IBAction func mapBtn(_ sender: Any) {
        print(self.revealViewController()?.frontViewController)
        var tab = self.revealViewController()?.frontViewController as! tabbar
        tab.gotoMap()
        self.revealViewController().revealToggle(animated: true)
    }
    @IBAction func favAdsbtn(_ sender: Any) {
        performSegue(withIdentifier: "favSeg", sender: nil)
    }
    @IBAction func ProfileBtn(_ sender: Any) {
        
       print(self.revealViewController()?.frontViewController)
        var tab = self.revealViewController()?.frontViewController as! tabbar
        tab.gotoProfile()
        
        self.revealViewController().revealToggle(animated: true)

    }
    
    @IBAction func Homebtn(_ sender: Any) {
        print(self.revealViewController()?.frontViewController)
        var tab = self.revealViewController()?.frontViewController as! tabbar
        tab.gotoHome()
        self.revealViewController().revealToggle(animated: true)
    }
    @IBOutlet weak var profileImageView: UIImageView!

   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
