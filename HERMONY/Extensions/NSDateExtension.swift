//
//  NSDateExtension.swift
//  Marsad
//
//  Created by Eng. Eman Rezk on 3/27/16.
//  Copyright © 2016 Eng. Eman Rezk. All rights reserved.
//

import Foundation

extension Date {
    
    struct Date {
        static let formatter = DateFormatter()
    }
    
    var dateString: String {
        //        Date.formatter.dateFormat = "yyyy-MM-dd"
        //        Date.formatter.dateFormat = "MMM dd, yyyy"
        Date.formatter.dateFormat = "dd MMM yyyy"
        
        //        Date.formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        Date.formatter.locale = NSLocale(localeIdentifier: "ar_EG") as Locale!
        
        return Date.formatter.string(from: self)
    }
    
    var timeString: String {
        Date.formatter.dateFormat = "HH:mm:ss" //"yyyy-MM-dd"
        return Date.formatter.string(from: self)
    }
    
    var dayString: String{
        Date.formatter.dateFormat = "EEEE"
        Date.formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        let dayName = Date.formatter.string(from: self)
        print("dayName:\(dayName)")
        return dayName
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self) == ComparisonResult.orderedDescending) // deadline is earlier than current date
    }
    
    var isEqualCurrentDate: Bool{
        return (NSDate().compare(self) == ComparisonResult.orderedSame)
    }
}
