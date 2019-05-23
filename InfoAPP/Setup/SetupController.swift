//
//  SetupController.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/9.
//  Copyright © 2019 zsw. All rights reserved.
//

import UIKit

class SetupController: SuperController {

    var tableView: UITableView! = nil
    var originalFrame: CGRect! = nil
    var imageView: UIImageView!
    let imageViewHeight: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "设置"
        
        self.imageView = UIImageView()
        self.imageView.frame = CGRect(x: 0, y: 88, width: KSCREEN_WIDTH,
                                      height: imageViewHeight)
        originalFrame = imageView.frame
        self.imageView.image = UIImage(named: "lotus3")
        self.imageView.contentMode = .scaleAspectFill
        
        view.addSubview(imageView)
        
        tableView =  UITableView(frame: CGRect(x: 0, y: 88, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT - 88), style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        tableView.tableFooterView = UIView.init()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        view.addSubview(tableView)
        
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: imageViewHeight))
        tableView.tableHeaderView = headView
        
        
    }

}

extension SetupController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset > 0 {
            imageView.frameY = originalFrame.origin.y - offset
        }else{
            self.imageView.frameH = originalFrame.size.height - offset

        }
    }
}

extension SetupController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
        

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01;
    }
}
extension SetupController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "cellId";
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! UITableViewCell;
        cell.selectionStyle = .none;
        cell.textLabel?.text = "条码一"
        
        return cell;
    }
    
}
