//
//  NewsDetailController.swift
//  NewsClient
//
//  Created by chihhao on 2019-10-21.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailController: UIViewController, UIScrollViewDelegate, WKNavigationDelegate   {
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
        setupFloatingControls()
    }
    
    // MARK: - To configure WebView -
    fileprivate func setupWebView()  {
        webView.scrollView.frame = webView.frame
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        view.addSubview(webView)
        webView.fillSuperview(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - To setup a floating view to save the interested news and its function -
    let floatingContainerView = UIView()
    fileprivate func setupFloatingControls()    {
        floatingContainerView.clipsToBounds = true
        floatingContainerView.layer.cornerRadius = 32
        self.view.addSubview(floatingContainerView)
        
        floatingContainerView.anchor(top: nil, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: UIScreen.main.bounds.width/2 - 32, bottom: -90, right: UIScreen.main.bounds.width/2 - 32), size: .init(width: 0, height: 64))
        
        let blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainerView.addSubview(blurVisualEffect)
        blurVisualEffect.fillSuperview()
        
        // Add the floating "Save" button to the current view
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        let getButton = UIButton(title: "GET", titleColor: .red, font: .boldSystemFont(ofSize: 16), width: 64, height: 32, cornerRadius: 16)
        getButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        floatingContainerView.addSubview(getButton)
        getButton.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    @objc fileprivate func handleTap()   {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = .identity
        }, completion: nil)
    }
    
    @objc fileprivate func handleSave()   {
        print("Article Saved")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translationY = -90 - (UIApplication.shared.statusBarUIView?.frame.height ?? 0)
        // Set up a transform variable to decide how the floatingContainerView would be rendered out
        let transform = self.webView.scrollView.contentOffset.y > 300 ? CGAffineTransform(translationX: 0, y: translationY) : .identity
        print("offset \(scrollView.contentOffset.y)")
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = transform
        }, completion: nil)
    }

}
