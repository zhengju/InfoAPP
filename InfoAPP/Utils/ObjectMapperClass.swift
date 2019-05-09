//
//  ObjectMapperClass.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/9.
//  Copyright © 2019 zsw. All rights reserved.
//

import Foundation
import ObjectMapper
//【iOS（swift）笔记-6】自定义ObjectMapper的时间转换https://blog.csdn.net/xihuandaxiaojie/article/details/79333888
class ObjectMapperDateTransform: TransformType {
    
    typealias Object = Date
    
    typealias JSON = String
    
    open func transformFromJSON(_ value: Any?) -> Date? {
        
        if let timeStr = value as? String {
            
            return DateUtil.str2Date(str: timeStr, format: DateUtil.DATEFORMAT.FORMAT_YMDHM_1.rawValue)
        }
        return nil
    }
    
    open func transformToJSON(_ value: Date?) -> String? {
        
        if let date = value {
            
            return DateUtil.date2Str(date: date, format: DateUtil.DATEFORMAT.FORMAT_YMDHM_1.rawValue)
        }
        return nil
        
    }
    
}
