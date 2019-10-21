//
//  Constants.swift
//  Taallam
//
//  Created by Eng. Eman Rezk on 5/1/17.
//  Copyright © 2017 Eng.Eman Rezk. All rights reserved.
//

import UIKit

let greenColor = UIColor(red: 68/255, green: 162/255, blue: 78/255, alpha: 1.0)

let darkGreenColor = UIColor(red: 59/255, green: 141/255, blue: 58/255, alpha: 1.0)

let lightGrayColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)

let Level = "مستوي"
let Teacher = "معلم"
let Student = "طالب"
let Question = "سؤال"
let emam = "الامام"

let fontName = "Avenir-Black"

let toastFont: CGFloat = 16.0

enum UserType: Int{
    case student = 1
    case teacher = 2
}

let Notification_OpenConversation = "openConversation"
let Notification_UpdateMessageBadge = "UpdateMessageBadge"
let Notification_UserInfoChanged = "UserInfoChanged"
let Notification_RefreshView = "RefreshView"

class Constants: NSObject {

}
