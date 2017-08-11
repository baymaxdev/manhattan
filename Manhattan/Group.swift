//
//  Group.swift
//  Manhattan
//
//  Created by gOd on 8/11/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import Foundation
import SwiftyJSON

class Group {
    var id: Int?
    var name: String?
    var userIds: [Int]?
    var photo: String?
    
    init () {
        id = 0
        name = ""
        userIds = []
        photo = ""
    }
    
    init (param: [String: JSON]) {
        id = param["id"]?.intValue
        name = param["name"]?.stringValue
        photo = param["photo"]?.stringValue
        let temp = param["users"]?.arrayValue
        userIds = []
        for element in temp! {
            userIds?.append(element.intValue)
        }
    }
}
