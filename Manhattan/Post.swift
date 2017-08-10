//
//  Post.swift
//  Manhattan
//
//  Created by gOd on 8/7/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import Foundation
import SwiftyJSON

class Post {
    var id: Int?
    var type: PostType?
    var postTitle: String?
    var postContent: String?
    var likes: [Int]?
    var comments: [Int]?
    var createdTime: String?
    var user: User?
    
    init () {
        id = 0
        type = .none
        postTitle = ""
        postContent = ""
        likes = []
        comments = []
        createdTime = ""
        user = User()
    }
    
    init (param: [String: JSON]) {
        id = param["id"]?.intValue
        type = (param["type"]?.stringValue).map { PostType(rawValue: $0) }!
        postTitle = param["postTitle"]?.stringValue
        postContent = param["postContent"]?.stringValue
        let array = param["likes"]?.arrayValue
        likes = []
        for element in array! {
            likes?.append(element.intValue)
        }
        let array1 = param["comments"]?.arrayValue
        comments = []
        for element in array1! {
            comments?.append(element.intValue)
        }
        createdTime = param["createdTime"]?.stringValue
        user = User(user: (param["userInfo"]?.dictionaryValue)!)
    }
}
