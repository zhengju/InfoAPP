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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        titleLable = UILabel();
        sourceLable = UILabel();
        infoImg = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier);

        titleLable.text = "寺库 X Art Chengdu线上线下同步博览会空降成都";
        titleLable.numberOfLines = 2;
        contentView.addSubview(titleLable);
        
        sourceLable.text = "中国新闻网";
        sourceLable.font = UIFont.systemFont(ofSize: 14);
        sourceLable.textColor = UIColor.gray;
        contentView.addSubview(sourceLable);

        infoImg.image = UIImage.init(imageLiteralResourceName: "lotus");
        contentView.addSubview(infoImg);
        
       
        
        titleLable.snp.makeConstraints { (make) ->Void in
            make.left.equalTo(contentView).offset(20);
            make.top.equalTo(contentView).offset(20);
            make.right.equalTo(infoImg.snp.left).offset(-20);
        }
        
        sourceLable.snp.makeConstraints { (make) ->Void  in
            make.left.equalTo(titleLable);
            make.bottom.equalTo(contentView).offset(-20);
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
    
}
