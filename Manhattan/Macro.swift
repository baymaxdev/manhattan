//
//  Macro.swift
//  Manhattan
//
//  Created by gOd on 8/5/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import Foundation
import UIKit

enum PostType : String {
    case blog = "B"
    case photo = "P"
    case video = "V"
    case none = ""
}

let APP_COLOR = UIColor(red: 128/255.0, green: 64/255.0, blue: 255/255.0, alpha: 1.0)
let BASE_URL = "http://192.168.1.119:5000/"
let SIGNUP_URL = "user/auth/signup/"
let LOGIN_URL = "user/auth/login/"
let FBLOGIN_URL = "user/auth/fblogin/"
let GETUSERBYID_URL = "user/getbyid/"
let UPDATEUSER_URL = "user/update/"
let POST_URL = "post/post/"
let LIKE_URL = "post/updatelike/"
let POSTGETALL_URL = "post/getall/"
let POSTGETBYUSERID_URL = "post/getbyuserid/"
let GETCOMMENTBYPOSTID_URL = "comment/getbypostid/"
let COMMENTPOST_URL = "comment/post/"
