//
//  InfoDetailController.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/5.
//  Copyright © 2019 zsw. All rights reserved.
//

import UIKit
import WebKit
class InfoDetailController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "资讯详情";
        
        let webView = WKWebView.init(frame: view.bounds);
        self.view.addSubview(webView);
        webView.load(URLRequest(url: URL(string: "http://mini.eastday.com/mobile/190505103745908.html")!));
        
    }
    
}
