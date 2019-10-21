//
//  Notification.swift
//  HERMONY
//
//  Created by magdy khaled on 3/21/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit

class Notification: UIViewController ,UITableViewDelegate,UITableViewDataSource{
 
    @IBOutlet weak var notificationTV: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! UITableViewCell
        return cell
    }



}
