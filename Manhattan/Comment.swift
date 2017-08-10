//
//  Comment.swift
//  Manhattan
//
//  Created by gOd on 8/9/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import Foundation

import Foundation
import SwiftyJSON

class Comment {
    var id: Int?
    var content: String?
    var user: User?
    
    init () {
        id = 0
        content = ""
        user = User()
    }
    
    init (param: [String: JSON]) {
        id = param["id"]?.intValue
        content = param["content"]?.stringValue
        user = User(user: (param["userInfo"]?.dictionaryValue)!)
    }
}
