//
//  User.swift
//  WorkGuru
//
//  Created by Lucky Clover on 5/2/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    var id:Int?
    var name: String?
    var email: String?
    var password: String?
    var dob: String?
    var userName: String?
    var interests: [String]
    var photo: String?
    var isFB: Bool?
    var skill: String?
    var education: String?
    var eduFrom: String?
    var eduTo: String?
    var bio: String?
    
    
    init (withFB: Bool, dictionary: [String: Any]) {
        self.id = 0
        self.email = dictionary["email"] as? String
        self.password = ""
        self.name = dictionary["name"] as? String
        self.dob = dictionary["birthday"] as? String
        self.interests = []
        let photoid = dictionary["id"] as? String
        self.userName = "fb" + photoid!
        self.photo = "http://graph.facebook.com/" + photoid! + "/picture?type=large"
        self.isFB = true
        self.skill = ""
        self.education = ""
        self.eduTo = ""
        self.eduFrom = ""
        self.bio = ""
    }
    
    init (user: [String: JSON]) {
        self.id = user["id"]?.intValue
        self.email = user["email"]?.stringValue
        self.password = user["password"]?.stringValue
        self.name = user["name"]?.stringValue
        self.dob = user["dob"]?.stringValue
        self.userName = user["userName"]?.stringValue
        self.photo = user["photo"]?.stringValue
        let array = user["interests"]?.arrayValue
        self.interests = []
        for element in array! {
            self.interests.append(element.stringValue)
        }
        self.isFB = user["isFB"]?.boolValue
        self.skill = ""
        self.education = ""
        self.eduTo = ""
        self.eduFrom = ""
        self.bio = ""
    }
    
    init () {
        self.id = 0
        self.email = ""
        self.password = ""
        self.name = ""
        self.dob = ""
        self.userName = ""
        self.photo = ""
        self.interests = []
        self.isFB = false
        self.skill = ""
        self.education = ""
        self.eduTo = ""
        self.eduFrom = ""
        self.bio = ""
    }
    
    func getUser() -> [String: Any?] {
        var user = [String: Any?]()
        
        user["id"] = self.id
        user["email"] = self.email
        user["password"] = self.password
        user["name"] = self.name
        user["dob"] = self.dob
        user["userName"] = self.userName
        user["photo"] = self.photo
        user["interests"] = self.interests
        user["isFB"] = self.isFB
        user["skill"] = self.skill
        user["education"] = self.education
        user["eduFrom"] = self.eduFrom
        user["eduTo"] = self.eduTo
        user["bio"] = self.bio
        
        return user
    }
    
    func setUser(_ user: [String: JSON]) {
        self.id = user["id"]?.intValue
        self.email = user["email"]?.stringValue
        self.password = user["password"]?.stringValue
        self.name = user["name"]?.stringValue
        self.dob = user["dob"]?.stringValue
        self.userName = user["userName"]?.stringValue
        self.photo = user["photo"]?.stringValue
        let array = user["interests"]?.arrayValue
        self.interests.removeAll()
        for element in array! {
            self.interests.append(element.stringValue)
        }
        self.isFB = user["isFB"]?.boolValue
        self.skill = user["skill"]?.stringValue
        self.education = user["education"]?.stringValue
        self.eduTo = user["eduTo"]?.stringValue
        self.eduFrom = user["eduFrom"]?.stringValue
        self.bio = user["bio"]?.stringValue
    }
}
