//
//  InfoCell.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/5.
//  Copyright © 2019 zsw. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class InfoCell: UITableViewCell {

    let titleLable:UILabel! //标题
    let sourceLable:UILabel! //来源
    let infoImg:UIImageView! //图片
    let dateLabel:UILabel! //图片
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        titleLable = UILabel()
        sourceLable = UILabel()
        infoImg = UIImageView()
        dateLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier);

        titleLable.text = "--";
        titleLable.numberOfLines = 2;
        contentView.addSubview(titleLable);
        
        sourceLable.text = "中国新闻网";
        sourceLable.font = UIFont.systemFont(ofSize: 14);
        sourceLable.textColor = UIColor.gray;
        contentView.addSubview(sourceLable);

        infoImg.image = UIImage.init(imageLiteralResourceName: "lotus2");
        contentView.addSubview(infoImg);
        
        dateLabel.font = UIFont.systemFont(ofSize: 12);
        dateLabel.textColor = UIColor.gray;
        contentView.addSubview(dateLabel)
        
        
        titleLable.snp.makeConstraints { (make) ->Void in
            make.left.equalTo(contentView).offset(20);
            make.top.equalTo(contentView).offset(20);
            make.right.equalTo(infoImg.snp.left).offset(-20);
        }
        
        sourceLable.snp.makeConstraints { (make) ->Void  in
            make.left.equalTo(titleLable);
            make.bottom.equalTo(contentView).offset(-20);
        }
        dateLabel.snp.makeConstraints { (make) ->Void  in
            make.left.equalTo(sourceLable.snp.right).offset(5);
            make.centerY.equalTo(sourceLable.snp.centerY);
        }
        
        infoImg.snp.makeConstraints { (make) ->Void in
            make.right.equalTo(contentView).offset(-20);
            make.centerY.equalTo(contentView);
            make.size.equalTo(CGSize(width: 90, height: 70));
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(infoModel: ContentlistModel){
        sourceLable.text = infoModel.source;
        titleLable.text = infoModel.title;
        dateLabel.text = DateUtil.timeBetween(date: infoModel.pubDate!)

        infoImg.kf.setImage(
            with: URL(string: infoModel.img));
    }
}
