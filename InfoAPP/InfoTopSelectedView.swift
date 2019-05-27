//
//  InfoTopSelectedView.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/7.
//  Copyright © 2019 zsw. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class InfoTopSelectedView: UIView {

   
    weak open var delegate: InfoTopSelectedViewProtocol?
  
    
    var scrollView:UIScrollView!

    var selectedButton: UIButton!
    var rightButton: UIButton!
    var datas:Array<ChannelListModel>!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        rightButton = UIButton(frame: CGRect(x: Int(self.frameW - 60), y: 0, width: 60, height: Int(self.frameH)))
        rightButton.addTarget(self, action: #selector(rightClick(button:)), for: .touchUpInside)
        rightButton.backgroundColor = UIColor.white
        rightButton.setImage(UIImage(named: "sanheng"), for: .normal)
        self.addSubview(rightButton)

    }
    
    
    func setDatas(datas:Array<ChannelListModel>) {
        self.datas = datas
        var buttonX = 0;
        for model in datas {
            let button = UIButton(frame: CGRect(x: buttonX, y: 0, width: 80, height: Int(self.frameH)))
            button.tag = 100 + buttonX/80;
            button.setTitle(model.name, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.red, for: .selected)
            button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
            scrollView.addSubview(button)
            
            if buttonX == 0 {
                button.isSelected = true
                selectedButton = button
            }
            
            buttonX = buttonX + 80
        }

        scrollView.contentSize = CGSize(width: self.datas.count*80, height: 0)
        self.addSubview(scrollView)
    }
    
    @objc func rightClick(button:UIButton){
        delegate?.rightClickAction()
    }
    
    
    @objc func buttonClick(button: UIButton) {
        let index = button.tag - 100;
 
        guard index < datas.count - 1  else {
            
            return;
        }
        
        
        if selectedButton != button {
            
            if selectedButton != nil {
                selectedButton.isSelected = false;
            }

            selectedButton = button;
            selectedButton.isSelected = true
            
            
            if delegate != nil {
                
                let model = datas[index]
                model.index = index
                datas[index] = model
                
                delegate?.topSeleted(model: datas[index])
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


protocol InfoTopSelectedViewProtocol : NSObjectProtocol {
    func topSeleted(model:ChannelListModel)
    func rightClickAction()
}
