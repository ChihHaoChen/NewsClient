//
//  NewsDetailController.swift
//  NewsClient
//
//  Created by chihhao on 2019-10-21.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift

class NewsDetailController: UIViewController, UIScrollViewDelegate, WKNavigationDelegate   {
    let realm = try! Realm()
    var detailedNews: Article?
    let savedArtice = SavedArticle()
    let webView: WKWebView =    {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    fileprivate let mode: Mode
    enum Mode {
        case readSavedArtile, readUnSavedArticle
    }
    
    
    init(mode: Mode, article: Article)   {
        self.mode = mode
        if mode == .readUnSavedArticle {
            self.detailedNews = article
            print("Article type \(article.self)")
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let url = URL(string: self.detailedNews?.url ?? "")
        let url = URL(string: self.detailedNews?.url ?? "")
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
        
        let getButton = UIButton(title: "SAVE", titleColor: .red, font: .boldSystemFont(ofSize: 12), width: 64, height: 16, cornerRadius: 16)
        getButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        floatingContainerView.addSubview(getButton)
        getButton.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    @objc fileprivate func handleTap()   {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = .identity
        }, completion: nil)
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
    // MARK: - To set up operations to write persistent data with Realm
    @objc fileprivate func handleSave()   {
        mappingSavedArticle()
        saveArticle(savedArticle: savedArtice)
    }
    
    fileprivate func mappingSavedArticle()  {
        guard let detailNewsChosen = detailedNews else { return }
        savedArtice.title = detailNewsChosen.title ?? ""
        savedArtice.newsDescription = detailNewsChosen.description ?? ""
        savedArtice.url = detailNewsChosen.url
        savedArtice.urlToImage = detailNewsChosen.urlToImage ?? ""
        savedArtice.publishedAt = detailNewsChosen.publishedAt ?? ""
        savedArtice.publisherName = detailNewsChosen.source?.name ?? ""
    }
    
    fileprivate func saveArticle(savedArticle: SavedArticle)  {
        do  {
            try realm.write {
                realm.add(savedArtice)
            }
        }   catch   {
            print("Error saving context, \(error)")
        }
    }
}
