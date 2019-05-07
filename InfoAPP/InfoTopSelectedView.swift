//
//  InfoTopSelectedView.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/7.
//  Copyright © 2019 zsw. All rights reserved.
//

import UIKit

class InfoTopSelectedView: UIView {

   
    weak open var delegate: InfoTopSelectedViewProtocol?
  
    
    var scrollView:UIScrollView!
    var titles: [String]!
    var titleStrings: [String]!
    var selectedButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        titles = ["头条","社会","国内","国际","娱乐","体育","军事","科技","财经","时尚"]
        titleStrings = ["top","shehui","guonei","guoji","yule","tiyu","junshi","keji","caijing","shishang"]
        
        var buttonX = 0;
        
        for title in titles {
            let button = UIButton(frame: CGRect(x: buttonX, y: 0, width: 60, height: Int(h(object: self))))
            button.tag = 100 + buttonX/60;
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.red, for: .selected)
            button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
            scrollView.addSubview(button)
            
            if buttonX == 0 {
                button.isSelected = true
                selectedButton = button
            }
            
            buttonX = buttonX + 60
        }
        
        scrollView.contentSize = CGSize(width: titles.count*60, height: 0)
        self.addSubview(scrollView)
    }
    
    @objc func buttonClick(button: UIButton) {
        let index = button.tag - 100;
 
        if selectedButton != button {
            
            if selectedButton != nil {
                selectedButton.isSelected = false;
            }

            selectedButton = button;
            selectedButton.isSelected = true
            
            if (delegate != nil) {
                delegate?.topSeleted(index: index)
            }
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


protocol InfoTopSelectedViewProtocol : NSObjectProtocol {
    func topSeleted(index:Int);
}
