//
//  BackendAPI.swift
//  Taallam
//
//  Created by Eng. Eman Rezk on 4/30/17.
//  Copyright © 2017 Eng.Eman Rezk. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON




let hostName = "http://aqary.elroily.com/api/"

//basic authorization username and Token
//let UserID = User.sharedInstance.id
//let Token = User.sharedInstance.deviceToken()




enum ServiceName: String {
    
    
    case login = "login"
    case registration = "registration"
    case foroget_password = "foroget_password?"
    case verify_verificationcode = "verify_verificationcode"
    case UpdateProfile = "UpdateProfile"
    case Categories = "Categories"
    case Store_Product = "Store_Product"
    case Products = "Products"
    case Productbyid = "Product"
    case search = "search"
    case searchByCategory = "searchByCategory"
    case AddFavorite = "AddFavorite"
    case Delete_Product = "Delete_Product"
    case MyFavorites = "MyFavorite"
    
    //Messages
    case MostViewProducts = "MostViewProducts"
    case MyProducts = "MyProducts"
    case map = "Map"
   
    
}





class BackendApi {
    
    
    // Step 2
    func perform(serviceName: ServiceName, parameters: [String: AnyObject]? = nil, completionHandler: @escaping (SwiftyJSON.JSON?, String?) -> Void)-> Void {
        
        let urlString = "\(hostName)\(serviceName.rawValue)"
        print(urlString)
        print("ServiceName:\(serviceName)  parameters: \(parameters)")
        
        let header: HTTPHeaders = [
            
            "Content-Type": "application/x-www-form-urlencoded",
//           "phone":01099638383,"password":123456
        ]
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: header).responseJSON{ response in
            debugPrint(response)
            
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                
                
                print("json[errorMessage].stringValue:\(json["message"].stringValue)")
                if  json["Status"] != "success"{
                    completionHandler(nil,json["message"].stringValue)
                }
                else{
                    
                    
                    completionHandler(json,nil)
                }
            }
            else{ //FAILURE
                print("error \(response.result.error) in serviceName: \(serviceName.rawValue)")
                
                
//                var cacheUrl = (response.request?.url?.absoluteString)!
//                if parameters != nil{
//                    cacheUrl += parameters!.description
//                }
//                let data = cache[cacheUrl]
//
//                if data != nil{
//                    let dataObject = NSKeyedUnarchiver.unarchiveObject(with: data! as Data)!
//                    completionHandler(JSON(dataObject),nil)
//                }
//                else{
                    completionHandler(nil,response.result.error?.localizedDescription)
//                }
            }
        }
    }
    
    func performGet(serviceName: ServiceName, parameters: [String: AnyObject]? = nil, completionHandler: @escaping (SwiftyJSON.JSON?, String?) -> Void)-> Void {
        
        let urlString = "\(hostName)\(serviceName.rawValue)"
        print(urlString)
        print("ServiceName:\(serviceName)  parameters: \(parameters)")
        
        let header: HTTPHeaders = [
            
            "Content-Type": "application/x-www-form-urlencoded",
            //           "phone":01099638383,"password":123456
        ]
        
        Alamofire.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: header).responseJSON{ response in
            debugPrint(response)
            
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                
                
                print("json[errorMessage].stringValue:\(json["message"].stringValue)")
                if  json["Status"] != "success"{
                    completionHandler(nil,json["message"].stringValue)
                }
                else{
                    
                    
                    completionHandler(json,nil)
                }
            }
            else{ //FAILURE
                print("error \(response.result.error) in serviceName: \(serviceName.rawValue)")
                
                
                //                var cacheUrl = (response.request?.url?.absoluteString)!
                //                if parameters != nil{
                //                    cacheUrl += parameters!.description
                //                }
                //                let data = cache[cacheUrl]
                //
                //                if data != nil{
                //                    let dataObject = NSKeyedUnarchiver.unarchiveObject(with: data! as Data)!
                //                    completionHandler(JSON(dataObject),nil)
                //                }
                //                else{
                completionHandler(nil,response.result.error?.localizedDescription)
                //                }
            }
        }
    }
    // Requesting MostViewedProducts
    func requestMostViewProducts(completion : @escaping ([String:Any]) -> Void){
     
        let urlString = "\(hostName)\(ServiceName.MostViewProducts.rawValue)"
        print("MostViewProducts URL" , urlString)
        Alamofire.request(urlString).responseJSON { (response) in
            if response.result.isSuccess{
                print("MostViewProducts is requested successfully")
                completion(response.result.value! as! [String : Any])
            } else {
                print("Error retreiving MostViewProducts")
            }
        }
    }
    
    // updating User Profile
    func updatingProfileRequest(parameters : [String : AnyObject], completion : @escaping ([String:Any])-> Void){
        let urlString = "\(hostName)\(ServiceName.UpdateProfile.rawValue)"
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil).responseJSON { (response) in
            if response.result.isSuccess{
                print("Updating profile is being processed")
                completion(response.result.value! as! [String : Any])
            }else {
                 print("Error while updating user profile")
            }
        }
    }
    
    // requesting Products
    func retreivingMyProducts( serviceName :String ,parameters : [String:String] , completion : @escaping
        ([String :Any]) -> Void){
        
        let header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let urlString = "\(hostName)\(serviceName)"
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: header).responseJSON { (response) in
            if response.result.isSuccess{
                print("Requesting \(serviceName) is being processed")
                completion(response.result.value! as! [String : Any])
            }else {
                print("Error retreiving \(serviceName)")
            }
        }
    }
    func getlocations( serviceName :String ,parameters : [String:Any] , completion : @escaping
        ([String :Any]) -> Void){
        
        let header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let urlString = "\(hostName)\(serviceName)"
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: header).responseJSON { (response) in
            if response.result.isSuccess{
                print("Requesting \(serviceName) is being processed")
                completion(response.result.value! as! [String : Any])
            }else {
                print("Error retreiving \(serviceName)")
            }
        }
    }
    
    
      // Requesting Product's Details by id
    func retreivingProductDetails( serviceName :String ,parameters : [String:Int] , completion : @escaping
        ([String :Any]) -> Void){
        
        let header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let urlString = "\(hostName)\(serviceName)"
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: header).responseJSON { (response) in
            if response.result.isSuccess{
                print("Requesting \(serviceName) is being processed")
                completion(response.result.value! as! [String : Any])
            }else {
                print("Error retreiving \(serviceName)")
            }
        }
    }
    
    
    // Deleting Items
    func deleteProduct( serviceName :String ,parameters : [String:Int] , completion : @escaping
        ([String :Any]) -> Void){
        
        let urlString = "\(hostName)\(serviceName)"
    Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil).responseJSON { (response) in
        print(response)
            if response.result.isSuccess{
                 print("Requesting \(serviceName) is being processed")
                   completion(response.result.value! as! [String : Any])
            }else {
                print("Error retreiving \(serviceName)")
            }
        }
    }
    
  
    // Add Favorite Items
    func addFavoriteProduct( serviceName :String ,parameters : [String:Any] , completion : @escaping
        ([String :Any]) -> Void){
        
        let urlString = "\(hostName)\(serviceName)"
    Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil).responseJSON { (response) in
            if response.result.isSuccess{
                 print("Requesting \(serviceName) is being processed")
                   completion(response.result.value! as! [String : Any])
            }else {
                print("Error retreiving \(serviceName)")
            }
        }
    }
    
    // search
    func searchMyProducts( serviceName :String ,parameters : [String:Any] , completion : @escaping
        ([String :Any]) -> Void){
        
        let header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let urlString = "\(hostName)\(serviceName)"
        print(parameters)
        print(urlString)
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: header).responseJSON { (response) in
            if response.result.isSuccess{
                print("Requesting \(serviceName) is being processed")
                completion(response.result.value! as! [String : Any])
            }else {
                print("Error retreiving \(serviceName)")
            }
        }
    }
    
    
     // search by category
    func searchByCategory( serviceName :String ,parameters : [String:Any] , completion : @escaping
        ([String :Any]) -> Void){
        
        let header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let urlString = "\(hostName)\(serviceName)"
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: header).responseJSON { (response) in
            if response.result.isSuccess{
                print("Requesting \(serviceName) is being processed")
                completion(response.result.value! as! [String : Any])
            }else {
                print("Error retreiving \(serviceName)")
            }
        }
    }
    
    func myFavorites( serviceName :String ,parameters : [String:Any] , completion : @escaping
        ([String :Any]) -> Void){
        
        let urlString = "\(hostName)\(serviceName)"
        let header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: header).responseJSON { (response) in
            print(response)
            if response.result.isSuccess{
                print("Requesting \(serviceName) is being processed")
                completion(response.result.value! as! [String : Any])
            }else {
                print("Error retreiving \(serviceName)")
            }
        }
    }


func requestCategories( serviceName :String , completion : @escaping
    ([String :Any]) -> Void){
    
    let urlString = "\(hostName)\(serviceName)"
    
    Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding(destination: .queryString), headers: nil).responseJSON { (response) in
        print(response)
        if response.result.isSuccess{
            print("Requesting \(serviceName) is being processed")
            completion(response.result.value! as! [String : Any])
        }else {
            print("Error retreiving \(serviceName)")
        }
    }
}

func findByCategory( serviceName :String ,parameters : [String:Any] , completion : @escaping
    ([String :Any]) -> Void){
    
    let urlString = "\(hostName)\(serviceName)"
    let header: HTTPHeaders = [
        "Content-Type": "application/x-www-form-urlencoded"
    ]
    Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: header).responseJSON { (response) in
        print(response)
        if response.result.isSuccess{
            print("Requesting \(serviceName) is being processed")
            print("SEARCHBYCATEGORY" , response.result.value!)
            completion(response.result.value! as! [String : Any])
        }else {
            print("Error retreiving \(serviceName)")
        }
      }
   }
}
