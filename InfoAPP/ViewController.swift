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
    var datas: [[ContentlistModel]]! = [[],[],[],[],[],[],[],[],[],[]]
    var channelLists:[ChannelListModel]!
    var topView: InfoTopSelectedView!
    var selectItemView: SelectItemView!
    var seletedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新闻头条"
        self.view.backgroundColor = UIColor.white

        initNavigationBar()
        
        topView = InfoTopSelectedView(frame: CGRect(x: 0, y: 88, width: KSCREEN_WIDTH, height: 40))
        topView.delegate = self
        self.view.addSubview(topView)

        tableView =  UITableView(frame: CGRect(x: 0, y: 128, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - 128), style: .plain)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.register(InfoCell.classForCoder(), forCellReuseIdentifier: "cellId")

        let arr = [
            ["name":"头条","channelId":"top"],
            ["name":"社会","channelId":"shehui"],
            ["name":"国内","channelId":"guonei"],
            ["name":"国际","channelId":"guoji"],
            ["name":"娱乐","channelId":"yule"],
            ["name":"体育","channelId":"tiyu"],
            ["name":"军事","channelId":"junshi"],
            ["name":"科技","channelId":"keji"],
            ["name":"财经","channelId":"caijing"],
            ["name":"时尚","channelId":"shishang"],
            ]
        channelLists = Mapper<ChannelListModel>().mapArray(JSONArray: arr)
        
        self.topView.setDatas(datas: self.channelLists)

        getTypeDetail(channelId: "top")

        selectItemView = SelectItemView(frame: CGRect(x: 0, y: KSCREEN_HEIGHT, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT))
        selectItemView.delegate = self
        let window = UIApplication.shared.delegate?.window!
        window!.addSubview(selectItemView)
        
    }
    
    

    func initNavigationBar() {

        let rightItem = UIBarButtonItem(title: "设置", style: .plain, target: self, action: #selector(rightAction))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func rightAction() {
        navigationController!.pushViewController(SetupController(), animated: true)
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
        contrlloer.url = model!.link;
        
        
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
    func topSeleted(model: ChannelListModel){

        getTypeDetail(channelId: model.channelId)
        
    }
    func rightClickAction(){
        UIView.animate(withDuration: 0.5) {
            self.selectItemView.frameY = 0
        }
    }
}
extension ViewController: SelectItemViewDelegate {
    func selectItemClose(dataArray datas:Array<ItemModel>) {
        UIView.animate(withDuration: 0.5) {
            self.selectItemView.frameY = KSCREEN_HEIGHT
        }
        //改变选择条
    }
}

extension ViewController {
    func getChannelList(){
        HttpManager.sharedInstance.getChannelList(success: { (success) in
            self.channelLists = success
            self.topView.setDatas(datas: self.channelLists)
            print(self.channelLists.count)
            self.getChannelDetail(channelId: "5572a108b3cdc86cf39001cd")
            
        }) { (fail) in
            
        }
    }
    
    func getTypeDetail(channelId:String){
        let hud = self.pleaseWait()
        HttpManager.sharedInstance.getDatas(patameter: ["type":channelId], success: { (success) in
            hud.hide()
            if self.datas.count > self.seletedIndex {
                self.datas.remove(at: self.seletedIndex)
            }
            
            self.datas.insert(success, at: self.seletedIndex)
            
            self.tableView.reloadData()
            
        }) { (fail) in
            
        }
    }
    func getChannelDetail(channelId:String){
        let hud = self.pleaseWait()
        HttpManager.sharedInstance.getChannelDetail(patameter: ["channelId":channelId], success: { (success) in
            hud.hide()
            if self.datas.count > self.seletedIndex {
                self.datas.remove(at: self.seletedIndex)
            }
            
            self.datas.insert(success, at: self.seletedIndex)
            
            self.tableView.reloadData()
            
        }) { (fail) in
            
        }
    }
}
