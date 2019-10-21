//
//  UITableViewExtension.swift
//  Taallam
//
//  Created by Eng. Eman Rezk on 6/1/17.
//  Copyright © 2017 Eng.Eman Rezk. All rights reserved.
//

import UIKit

extension UITableView{

    var spinner:UIActivityIndicatorView{
        return self.tableFooterView as! UIActivityIndicatorView
    }
    
    func addActivityIndicatorToFooter(){
        var spinner = UIActivityIndicatorView()
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.color = greenColor
        //        spinner.backgroundColor = UIColor.red
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50)
        self.tableFooterView = spinner
    }
    
    
    func removeUpToDateView(){
        //        let label = tableFooterView?.viewWithTag(200000) as? UILabel
        //        label?.removeFromSuperview()
        ////        self.tableFooterView?.frame.size.height = 0
        //        self.contentSize.height -= 50
        
        self.tableFooterView = nil
    }
    
    func addUpToDateView(){
        
        let label = UILabel()
        label.text = "You are up to date"
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.tag = 200000
        label.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50)
        
        self.tableFooterView = label
    }
}
