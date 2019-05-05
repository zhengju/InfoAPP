//
//  ViewController.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/5.
//  Copyright © 2019 zsw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tableView :UITableView! = nil
    
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
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
        
        self.navigationController?.pushViewController(InfoDetailController(), animated: true);
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01;
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cellId";
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! InfoCell;
        cell.selectionStyle = .none;
        cell.infoImg.kf.indicatorType = .none;
        cell.infoImg.kf.setImage(
            with: URL(string: "http://07imgmini.eastday.com/mobile/20190505/20190505103745_dd14d07e711771f435d73241238b63a7_1_mwpm_03200403.jpg"));
            
        return cell;
    }
    
    
}
