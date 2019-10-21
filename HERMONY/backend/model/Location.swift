//
//  File.swift
//  HERMONY
//
//  Created by 2p on 5/11/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit

//


class Location: NSObject, NSCoding {
    
    var longitude = ""
    var latitude = ""
    var placeID = ""
    var ar_title = ""
    var en_title = ""
    var image = [String:Any]()
    
    var isUserPreferred = false
    override init() {
        ar_title = ""
        longitude = ""
        latitude = ""
        placeID = ""
        en_title = ""
        image = ["":""]
    }
    //{
    //    "lat": "30.0444",
    //    "lng": "31.2357",
    //    "id": 9,
    //    "ar_title": "منزل",
    //    "en_title": "home",
    //    "view": 2,
    //    "image": {
    //        "id": 12,
    //        "img": "15555237261.png"
    //    }
    //},
    init(data:[String:Any]) {
        ar_title = data["ar_title"] as! String
        longitude = String(data["lng"] as! Double)
        latitude = String(data["lat"] as! Double)
        en_title  = data["en_title"] as! String
        placeID = String(data["id"] as! Double)
        image = data["image"] as! [String:Any]
        print(image)
        print(placeID)
        print(ar_title)
    }
    init(name:String, long:String, lat:String) {
        self.ar_title = name
        self.longitude = long
        self.latitude = lat
    }
    
    required init(coder aDecoder: NSCoder) {
        self.isUserPreferred = aDecoder.decodeBool(forKey: "isUserPreferred")
        self.ar_title = aDecoder.decodeObject(forKey: "ar_title") as! String
        self.longitude = aDecoder.decodeObject(forKey: "longitude") as! String
        self.latitude = aDecoder.decodeObject(forKey: "latitude") as! String
        self.en_title = aDecoder.decodeObject(forKey: "en_title") as! String
        self.placeID = aDecoder.decodeObject(forKey: "id") as! String
//        self.image = aDecoder.decodeObject(forKey: "image") as! String
    }
    
    func encode(with coder:NSCoder) {
        coder.encode(isUserPreferred, forKey: "isUserPreferred")
        coder.encode(ar_title, forKey: "ar_title")
        coder.encode(longitude, forKey: "longitude")
        coder.encode(latitude, forKey: "latitude")
        coder.encode(en_title, forKey: "en_title")
        coder.encode(placeID, forKey: "id")
//        coder.encode(image , forKey: "image")
    }
 
}
