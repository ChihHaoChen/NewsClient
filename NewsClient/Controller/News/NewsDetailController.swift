//
//  NewsDetailController.swift
//  NewsClient
//
//  Created by chihhao on 2019-10-21.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailController: UIViewController    {
    let webView: WKWebView =    {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let detailUrl: String
    init(url: String)   {
        self.detailUrl = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: self.detailUrl)
        let detailWeb = URLRequest(url: url!)
        setupWebView()
        webView.load(detailWeb)
    }
    
    fileprivate func setupWebView()  {
        view.addSubview(webView)
        webView.fillSuperview(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
}
