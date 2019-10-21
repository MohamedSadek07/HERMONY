//
//  StringExtension.swift
//  Taallam
//
//  Created by Eng. Eman Rezk on 4/30/17.
//  Copyright © 2017 Eng.Eman Rezk. All rights reserved.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func getDateFromUnknownFormat() -> Date?{
        
        let dateFormats = ["yyyy-MM-dd'T'HH:mm:ss","yyyy-MM-dd'T'HH:mm:ss.S"]
        //        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.S"
        var date: Date?
        
        for dateFormat in dateFormats{
            date = formatted(dateFormat)
            if ((date) != nil) {
                break;
            }
        }
        return date
    }
    
    
    func toDate() -> Date{
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ar_EG") as Locale!
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        print("self: \(self)")
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)! as Date
        
        //Return Parsed Date
        return dateFromString
    }
    
    
    func formatted(_ format:String) -> Date? {
        //        print("format:\(format) stringSelf:\(self)")
        
        let formatter = DateFormatter()
        
        //Specify Format of String to Parse
        formatter.dateFormat = format
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.autoupdatingCurrent
        
        return formatter.date(from: self)
    }
    
    
    //    func getDateFromJson() -> String{
    //        // Convert incoming Date
    //        let formatter = DateFormatter()
    //
    //
    ////        self =  formatter.string(from: NSDate())
    //
    //        // Expect date in this format "/Date(1268123281843)/"
    //        int startPos = (int)[dateString rangeOfString:@"("].location+1;
    //        int endPos = (int)[dateString rangeOfString:@")"].location;
    //        NSRange range = NSMakeRange(startPos,endPos-startPos);
    //        unsigned long long milliseconds = [[dateString substringWithRange:range] longLongValue];
    //        NSLog(@"%llu",milliseconds);
    //        NSTimeInterval interval = milliseconds/1000;
    //        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    //
    //        [formatter setDateFormat:@"yyyy-mm-dd"];
    //        return [formatter stringFromDate:date];
    //    }
    
    
    
    var arabicStringNumber: String{
        print("self:\(self)")
        let number = NSNumber(value: Int(self)!)
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ar_EG")
        return formatter.string(from: number)!
    }
    
    //        func convertEngNumToPersianNum(num: String)->String{
    //            let number = NSNumber(value: Int(num)!)
    //            let format = NumberFormatter()
    //            format.locale = Locale(identifier: "ar_EG")
    //            let faNumber = format.string(from: number)
    //    
    //            return faNumber!
    //        }
    
}
