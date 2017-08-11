//
//  Video.swift
//  Manhattan
//
//  Created by gOd on 8/10/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import Foundation
import SwiftyJSON

class Video {
    var id: Int?
    var title: String?
    var description: String?
    var thumbnail: String?
    var sectionId: Int?
    var path: String?
    
    init () {
        id = 0
        title = ""
        description = ""
        thumbnail = ""
        sectionId = 0
        path = ""
    }
    
    init (param: [String: JSON]) {
        id = param["id"]?.intValue
        title = param["title"]?.stringValue
        description = param["description"]?.stringValue
        sectionId = param["sectionId"]?.intValue
        thumbnail = param["thumbnail"]?.stringValue
        path = param["path"]?.stringValue
    }
}
