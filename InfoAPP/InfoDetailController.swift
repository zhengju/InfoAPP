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

    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "资讯详情";
        
        let webView = WKWebView.init(frame: view.bounds);
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view.addSubview(webView);
        webView.load(URLRequest(url: URL(string: url)!));
        
    }
    
}
extension InfoDetailController: WKUIDelegate{
    
}
extension InfoDetailController: WKNavigationDelegate{
    
}
