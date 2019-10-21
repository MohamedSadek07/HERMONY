//
//  APIControlManager.swift
//  Taallam
//
//  Created by Eng. Eman Rezk on 5/7/17.
//  Copyright © 2017 Eng.Eman Rezk. All rights reserved.
//
//
//import Foundation
//import SwiftyJSON
//
//class APIControlManager {
//    
//    static let sharedInstance = APIControlManager()
//    
//    fileprivate init() {} //This prevents others from using the default '()' initializer for this class.
//    
//    
//    func getUnreadMessagesNumber(){
//        
//        DispatchQueue.main.async{
//            let parameters = [kUserID: User.sharedInstance.id!]
//            
//            let api = BackendApi()
//            api.perform(serviceName: ServiceName.UserUnreadMessagesNumber, parameters: parameters as [String : AnyObject]?) { (JSON, String) -> Void in
//                
//                if String == nil{
//                    User.sharedInstance.unreadMessageCounter = JSON!["Count"].intValue
//                    print("unreadMessageCounter:\(JSON?["Count"].intValue)")
//                }
//            }
//        }
//        
//    }
//    
//    func getNotificationCount(){
//        
//        DispatchQueue.main.async{
//            let parameters = [kUserID: User.sharedInstance.id!]
//            
//            let api = BackendApi()
//            api.perform(serviceName: ServiceName.GetNoitificationNumber, parameters: parameters as [String : AnyObject]?) { (JSON, String) -> Void in
//                print("getNotificationCount:\(JSON)")
//                
//                if String == nil{
//                    User.sharedInstance.notificationCounter = JSON!["NotificationNumber"].intValue
//                    print("Count:\(JSON?["NotificationNumber"].intValue)")
//                }
//            }
//        }
//    }
//    
//    
//    func getUserProfileDetails(_ selectedUserID: String = User.sharedInstance.id!, userId: String = User.sharedInstance.id!, completionHandler completion:((Bool, User?) -> Void)? = nil){
//        
//        DispatchQueue.main.async{
//            
//            let parameters = ["SelectedUserID": selectedUserID,
//                              kUserID: userId]
//            print(parameters);
//            
//            let api = BackendApi()
//            api.perform(serviceName: ServiceName.GetUserProfileDetails, parameters: parameters as [String : AnyObject]?) { (JSON, String) -> Void in
//                if String != nil{
//                    completion?(false, nil)
//                }
//                else{
//                    
//                    let user = User()
//                    print("User.id:\(user.id)")
//                    
//                    user.id = JSON?["UserID"].stringValue
//                    user.name = JSON!["UserName"].stringValue
//                    user.pictureURL = JSON!["UserPictureURL"].stringValue
//                    user.pictureURL = user.pictureURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? user.pictureURL
//                    
//                    user.about = JSON!["about"].stringValue
//                    user.followersNumber = JSON!["FollowersNumber"].intValue
//                    user.isFollowing = JSON!["IsFollowing"].boolValue
//                    
//                    print("user.name:\(user.name)")
//                    print("User.sharedInstance.name:\(User.sharedInstance.name)")
//                    
//                    for followerJson in JSON!["SixFollowers"].arrayValue{
//                        let follower = Follower()
//                        follower.getDateFromJSON(followerJson)
//                        user.followersList.append(follower)
//                    }
//                    print(JSON!["FourBooks"])
//
//                    for bookJson in JSON!["FourBooks"].arrayValue{
//                        let book = UserBook()
//                        book.getDateFromJSON(bookJson)
//                        user.booksList.append(book)
//                    }
//                    
//                    if user.id == User.sharedInstance.id{
//                        user.type = User.sharedInstance.type
//                        user.isFirstTime = User.sharedInstance.isFirstTime
//                        user.notificationCounter = User.sharedInstance.notificationCounter
//                        user.unreadMessageCounter = User.sharedInstance.unreadMessageCounter
//                        user.saveData()
//                        
//                        User.sharedInstance.loadData()
//                    }
//                    
//                    completion?(true, user)
//                    
//                }
//            }
//        }
//    }
//    
//}
