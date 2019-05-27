//
//  HttpManager.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/27.
//  Copyright © 2019 zsw. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

class HttpManager: NSObject {
    class var sharedInstance: HttpManager {
        
        struct Static {
            static var instance: HttpManager = HttpManager()
        }

        return Static.instance
    }
    
    func getChannelList(success:@escaping (_ successd:Array<ChannelListModel>)->(),fail:(_ failed:Error)->()){
        Alamofire.request("http://ali-news.showapi.com/channelList", parameters: ["":""], headers: ["Authorization":"APPCODE 4c0aa04ae3a74d57996a169ae94c78e6"]).responseJSON { (response) in
            
            
            let dataArr: Array<ChannelListModel>
            
            if response.result.isSuccess {
                if response.result.value != nil{
                    
                    switch response.result{
                    case.success(let json):

                        print(JSON.init(arrayLiteral: json))
                        
                        
                        let dict = json as! Dictionary<String,AnyObject>
                        
                        let result = dict["showapi_res_body"]!["channelList"]

                        dataArr = Mapper<ChannelListModel>().mapArray(JSONArray: result as! [[String : Any]])

                        success(dataArr)

                        break
                    case .failure(let error):
                        print("\(error)")
                        break
                        
                    }
                    
                }
                
            }
            
        }
    }
    
    func getChannelDetail(patameter:Parameters, success:@escaping (_ successd:Array<ContentlistModel>)->(),fail:(_ failed:Error)->()) {
        Alamofire.request("http://ali-news.showapi.com/newsList", parameters: patameter, headers: ["Authorization":"APPCODE 4c0aa04ae3a74d57996a169ae94c78e6"]).responseJSON { (response) in
            
             let dataArr: Array<ContentlistModel>
            if response.result.isSuccess {
                if response.result.value != nil{
                    
                    switch response.result{
                    case.success(let json):

                        print(JSON.init(arrayLiteral: json))
                        
                        let dict = json as! Dictionary<String,AnyObject>
                        
                        let pagebean = dict["showapi_res_body"]!["pagebean"] as! Dictionary<String,AnyObject>
                        let contentlist = pagebean["contentlist"]
                        
                        dataArr = Mapper<ContentlistModel>().mapArray(JSONArray: contentlist as! [[String : Any]])
                        
                        success(dataArr)

                        break
                    case .failure(let error):
                        print("\(error)")
                        break
                        
                    }
                    
                }
                
            }
        }
    }
    func getDatas(patameter:Parameters, success:@escaping (_ successd:Array<ContentlistModel>)->(),fail:(_ failed:Error)->()) {
        
        //请求接口数据
        Alamofire.request("http://toutiao-ali.juheapi.com/toutiao/index", parameters: patameter, headers: ["Authorization":"APPCODE 4c0aa04ae3a74d57996a169ae94c78e6"]).responseJSON { (response) in
            if response.result.isSuccess {
                if response.result.value != nil{
                    
                    switch response.result{
                    case.success(let json):

                        let dict = json as! Dictionary<String,AnyObject>
                        let result = dict["result"]!["data"]

                        let  dataArr = Mapper<ContentlistModel>().mapArray(JSONArray: result as! [[String : Any]])

                        success(dataArr)

                        break
                    case .failure(let error):
                        print("\(error)")
                        break
                        
                    }
                    
                }
                
            }
        }
    }
}
