//
//  User.swift
//  WorkGuru
//
//  Created by Lucky Clover on 5/2/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import Foundation

class User {
    var firstName: String?
    var lastName: String?
    var name: String?
    var email: String?
    var dob: String?
    var userName: String?
    var interests: [String]
    var photo: String?
    var isFB: Bool?
    
    
    init (withFB: Bool, dictionary: [String: Any]) {
        self.firstName = dictionary["first_name"] as? String
        self.lastName = dictionary["last_name"] as? String
        self.email = dictionary["email"] as? String
        self.name = dictionary["name"] as? String
        self.dob = dictionary["birthday"] as? String
        self.interests = []
        let id = dictionary["id"] as? String
        self.userName = "fb" + id!
        self.photo = "http://graph.facebook.com/" + id! + "/picture?type=large"
        self.isFB = true
    }
    
    init () {
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.name = ""
        self.dob = ""
        self.userName = ""
        self.photo = ""
        self.interests = []
        self.isFB = false
    }
    
    func getUser() -> [String: Any?] {
        var user = [String: Any?]()
        
        user["email"] = self.email
        user["firstName"] = self.firstName
        user["lastName"] = self.lastName
        user["name"] = self.name
        user["dob"] = self.dob
        user["userName"] = self.userName
        user["photo"] = self.photo
        user["interests"] = self.interests
        user["isFB"] = self.isFB
        
        return user
    }
    
    func setUser(_ user: [String: Any]) {
        self.email = user["email"] as? String
        self.firstName = user["firstName"] as? String
        self.lastName = user["lastName"] as? String
        self.name = user["name"] as? String
        self.dob = user["dob"] as? String
        self.userName = user["userName"] as? String
        self.photo = user["photo"] as? String
        self.interests = user["interests"] as! [String]
        self.isFB = user["isFB"] as? Bool
    }
}
