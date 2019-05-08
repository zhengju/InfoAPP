//
//  InfoModel.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/6.
//  Copyright © 2019 zsw. All rights reserved.
//

import UIKit
import ObjectMapper
class InfoModel: Mappable {
    
    var author_name: String!
    var title: String!
    var url: String!
    var thumbnail_pic_s: String!
    var date: String!
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        author_name <- map["author_name"]
        title       <- map["title"]
        url         <- map["url"]
        thumbnail_pic_s <- map["thumbnail_pic_s"]
        date <- map["date"]
    }

}
