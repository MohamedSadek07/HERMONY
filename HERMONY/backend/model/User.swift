


import Foundation
import Alamofire
import SwiftyJSON


class User: NSObject, NSCoding {
    
    static let sharedInstance = User()
    
    var id: String?
    var name: String = ""
    var email: String?
    var facebook_id: String?
    var phone: String = ""
    var address: String = ""
    var admin: Int?
    var isverified: String = ""
    var status: String = ""
    var lat: String = ""
    var lng: String = ""
    var img: String = ""
    var token: String = ""
    
    override init() {
        super.init()
        
    }

required convenience init(coder aDecoder: NSCoder) {
    self.init()
    User.sharedInstance.id = aDecoder.decodeObject(forKey: "id") as? String
    User.sharedInstance.name = aDecoder.decodeObject(forKey: "name") as! String
    User.sharedInstance.email = aDecoder.decodeObject(forKey: "email") as? String
    User.sharedInstance.facebook_id = aDecoder.decodeObject(forKey: "facebook_id") as! String
    User.sharedInstance.phone = aDecoder.decodeObject(forKey: "phone") as! String
    User.sharedInstance.admin = aDecoder.decodeObject(forKey: "admin") as? Int
    User.sharedInstance.isverified = (aDecoder.decodeObject(forKey: "isverified") as? String)!
    User.sharedInstance.status = aDecoder.decodeObject(forKey: "status") as! String
    User.sharedInstance.lat = aDecoder.decodeObject(forKey: "lat") as! String
    User.sharedInstance.lng = aDecoder.decodeObject(forKey: "lng") as! String
    User.sharedInstance.img = aDecoder.decodeObject(forKey: "img") as! String
    User.sharedInstance.token = aDecoder.decodeObject(forKey: "token") as! String
    
    
}

func encode(with coder: NSCoder) {
    
    coder.encode(id, forKey: "id")
    coder.encode(name, forKey: "name")
    coder.encode(email, forKey: "email")
    coder.encode(facebook_id, forKey: "facebook_id")
    coder.encode(phone, forKey: "phone")
    coder.encode(admin, forKey: "admin")
    coder.encode(isverified, forKey: "isverified")
    coder.encode(status, forKey: "status")
    coder.encode(lat, forKey: "lat")
    coder.encode(lng, forKey: "lng")
    coder.encode(img, forKey: "img")
    coder.encode(token, forKey: "token")
    
}

func loadData(){
    let userDefaults = UserDefaults.standard
    NSKeyedUnarchiver.unarchiveObject(with: (userDefaults.object(forKey: "User") as! NSData) as Data)
}

func saveData(){
    print("self:\(self)")
    let data = NSKeyedArchiver.archivedData(withRootObject: self)
    UserDefaults.standard.set(data, forKey: "User")
}


func getDateFromJSON(_ json: JSON){
    print(json["id"])
    self.id = json["id"].stringValue
    self.phone = json["phone"].stringValue
    self.name = json["name"].stringValue
    self.img = json["img"].stringValue
    self.lat = json["lat"].stringValue
    self.lng = json["lng"].stringValue
    self.email = json["email"].stringValue
    self.token = json["token"].stringValue
    self.address = json["address"].stringValue
  
    self.status = json["status"].stringValue
    self.admin = json["admin"].intValue
}


func isRegistered() -> Bool{
    let defaults = UserDefaults.standard
    return defaults.bool(forKey: "IsRegistered")
}

func setIsRegister(_ registered: Bool){
    let defaults = UserDefaults.standard
    defaults.set(registered, forKey: "IsRegistered")
}

func deviceToken() -> String{
    let defaults = UserDefaults.standard
    if defaults.string(forKey: "DeviceToken") != nil{
        return defaults.string(forKey: "DeviceToken")!
    }
    else{
        return ""
    }
}
func setDeviceToken(_ deviceToken: String){
    let defaults = UserDefaults.standard
    defaults.set(deviceToken, forKey: "DeviceToken")
}


func logOut(){
    
//    if User.sharedInstance.isFB && (FBSDKAccessToken.current() != nil){
//        FBSDKLoginManager().logOut()
//    }
    
    let deviceToken = self.deviceToken()
    
    // removeUserData
    let appDomain = Bundle.main.bundleIdentifier!
    
    UserDefaults.standard.removePersistentDomain(forName: appDomain)
    
    self.setDeviceToken(deviceToken)
    let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    UserDefaults.standard.set(versionNumber + buildNumber, forKey: "AppVersion")
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.setLoginViewAsRoot()
}

}





