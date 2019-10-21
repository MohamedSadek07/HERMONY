//
//  tabbar.swift
//  HERMONY
//
//  Created by Magdy rizk on 4/12/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialBottomAppBar
class tabbar: UITabBarController {
    @IBOutlet weak var tabbar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//      tabbar.selectedItem = tabbar.items[1] as! UITabBarItem
//        var contr = self.viewControllers![1] as! UINavigationController
       gotoHome()
//        homeNavigation
        
    }
    
    func gotoHome()  {
         self.selectedViewController = self.viewControllers![1] as! UINavigationController
    }
    func gotoProfile()  {
        self.selectedViewController = self.viewControllers![0] as! UINavigationController
    }
    
    func gotoMap()  {
        self.selectedViewController = self.viewControllers![2] as! UINavigationController
    }

}
