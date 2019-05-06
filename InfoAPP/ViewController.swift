//
//  ViewController.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/5.
//  Copyright © 2019 zsw. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
class ViewController: UIViewController {
    
    var tableView :UITableView! = nil
    var datas:[InfoModel]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "资讯新闻";
        self.view.backgroundColor = UIColor.white;
        
        tableView =  UITableView(frame: view.bounds, style: .plain);
        self.view.addSubview(tableView);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = UIView.init();
        tableView.register(InfoCell.classForCoder(), forCellReuseIdentifier: "cellId");
        
        //请求接口数据
        Alamofire.request("http://toutiao-ali.juheapi.com/toutiao/index", parameters: ["type":"shehui"], headers: ["Authorization":"APPCODE 4c0aa04ae3a74d57996a169ae94c78e6"]).responseJSON { (response) in
            if response.result.isSuccess {
                if response.result.value != nil{

                    switch response.result{
                    case.success(let json):
                        let dict = json as! Dictionary<String,AnyObject>
                        let result = dict["result"]!["data"]
//                        print("\(String(describing: result))")
                        
                        self.datas = Mapper<InfoModel>().mapArray(JSONArray: result as! [[String : Any]]);
                        
                        self.tableView.reloadData();
                        
                        break
                    case .failure(let error):
                        print("\(error)")
                        break
                        
                    }

                }
                
            }
        };
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
        
        let model = datas?[indexPath.row];
        let contrlloer = InfoDetailController();
        contrlloer.url = model!.url;
        
        
        self.navigationController?.pushViewController(contrlloer, animated: true);
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01;
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = datas?[indexPath.row];
        
        let cellId = "cellId";
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! InfoCell;
        cell.selectionStyle = .none;
        cell.infoImg.kf.indicatorType = .none;
        cell.setModel(infoModel: model!);
        
            
        return cell;
    }
    
    
}
