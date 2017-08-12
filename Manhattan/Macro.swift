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

let strInterests = ["Economy", "Military", "Culture", "Technology", "Politics", "Healthcare", "Entertainment", "Sports", "Arts", "Film", "Video"]

let S3BUCKETNAME = "dariya-manhattan"
let AWSACCESSKEYID = "AKIAIDNFYLAKCORWYOPQ"
let AWSSECRETKEY = "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"
let APP_COLOR = UIColor(red: 128/255.0, green: 64/255.0, blue: 255/255.0, alpha: 1.0)

let BASE_URL = "http://192.168.1.119:5000/"

let SIGNUP_URL = "user/auth/signup/"
let LOGIN_URL = "user/auth/login/"
let FBLOGIN_URL = "user/auth/fblogin/"
let GETUSERBYID_URL = "user/getbyid/"
let UPDATEUSER_URL = "user/update/"
let SEARCHUSER_URL = "user/search/"
let FOLLOWUSER_URL = "user/follow/"
let CHECKUSERNAME_URL = "user/checkusername/"
let CHECKEMAIL_URL = "user/checkemail/"
let POST_URL = "post/post/"
let LIKE_URL = "post/updatelike/"
let POSTGETALL_URL = "post/getall/"
let POSTGETBYUSERID_URL = "post/getbyuserid/"
let GETCOMMENTBYPOSTID_URL = "comment/getbypostid/"
let COMMENTPOST_URL = "comment/post/"
let COURSEGETALL_URL = "course/getall/"
let COURSEGETBYUSERID_URL = "course/getbyuserid/"
let COURSEGETALLVIDEOS_URL = "course/getallvideos/"
let GROUPGETALL_URL = "group/getall/"
let GROUPGETBYID_URL = "group/getbyid/"
let GROUPGETBYUSERID_URL = "group/getbyuserid/"
let GROUPCREATE_URL = "group/create/"
