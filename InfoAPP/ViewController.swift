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
class ViewController: SuperController {
    
    var tableView: UITableView! = nil
    var datas: [[InfoModel]]! = [[],[],[],[],[],[],[],[],[],[]]
    var types: [String]!
    var topView: InfoTopSelectedView!
    var seletedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新闻头条"
        self.view.backgroundColor = UIColor.white
        
        initNavigationBar()
        
        topView = InfoTopSelectedView(frame: CGRect(x: 0, y: 88, width: KSCREEN_WIDTH, height: 40))
        topView.delegate = self
        self.view.addSubview(topView)
        
        types = ["top","shehui","guonei","guoji","yule","tiyu","junshi","keji","caijing","shishang"]
        
        tableView =  UITableView(frame: CGRect(x: 0, y: 128, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - 128), style: .plain)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.register(InfoCell.classForCoder(), forCellReuseIdentifier: "cellId")
 
        getDatas(index: seletedIndex);
        
    }
    
    func initNavigationBar() {

        let rightItem = UIBarButtonItem(title: "设置", style: .plain, target: self, action: #selector(rightAction))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func rightAction() {
        navigationController!.pushViewController(SetupController(), animated: true)
    }
    
    func getDatas(index: Int) {

        let hud = self.pleaseWait()
        
        //请求接口数据
        Alamofire.request("http://toutiao-ali.juheapi.com/toutiao/index", parameters: ["type":types[seletedIndex]], headers: ["Authorization":"APPCODE 4c0aa04ae3a74d57996a169ae94c78e6"]).responseJSON { (response) in
            if response.result.isSuccess {
                if response.result.value != nil{
                    
                    
                    
                    switch response.result{
                    case.success(let json):
                        
                        hud.hide()
//                        self.successNotice("Success", autoClear: true)
                        
                        print(JSON.init(arrayLiteral: json))
                        
                        let dict = json as! Dictionary<String,AnyObject>
                        let result = dict["result"]!["data"]
                        
//                        self.datas.removeAll()
                        
                        //self.datas[self.seletedIndex];
                        
                        let  dataArr = Mapper<InfoModel>().mapArray(JSONArray: result as! [[String : Any]])
                    
                        if self.datas.count > self.seletedIndex {
                            self.datas.remove(at: self.seletedIndex)
                        }
                        
                        
                        
                        self.datas.insert(dataArr, at: self.seletedIndex)

                        self.tableView.reloadData()
                        
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

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
        
        let model = datas?[seletedIndex][indexPath.row];
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
        return datas![seletedIndex].count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = datas?[seletedIndex][indexPath.row];
        
        let cellId = "cellId";
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! InfoCell;
        cell.selectionStyle = .none;
        cell.infoImg.kf.indicatorType = .none;
        cell.setModel(infoModel: model!);
        
        return cell;
    }
    
}

extension ViewController : InfoTopSelectedViewProtocol {
    func topSeleted(index: Int) {
        seletedIndex = index
        getDatas(index: index)
    }
}
