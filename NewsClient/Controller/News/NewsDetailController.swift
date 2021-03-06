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

class NewsDetailController: UIViewController, UIScrollViewDelegate, WKNavigationDelegate{
	
	let realm = try! Realm()
	var detailedNews: Article?
	
	let activityIndicator = UIActivityIndicatorView(color: .systemGray, style: .large)
	lazy var floatingContainerView = WebButtonView(viewBackgroundColor: ((mode == .readUnSavedArticle) ? .green : .red), buttonImage: ((mode == .readUnSavedArticle) ? "push-pin-90" : "unpin-90"))
	
	var savedArticle = SavedArticle()
	let filePathRealm = Realm.Configuration.defaultConfiguration.fileURL
	
	
	let webView: WKWebView =    {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // Addition of mode to check if the current article has been saved
    fileprivate let mode: Mode
    enum Mode {
        case readSavedArticle, readUnSavedArticle
    }
    
	
    init(mode: Mode, article: Article)   {
        self.mode = mode
        self.detailedNews = article
        super.init(nibName: nil, bundle: nil)
    }
    
	
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: self.detailedNews?.url ?? "")
        let detailWeb = URLRequest(url: url!)
		
        setupWebView()
        webView.load(detailWeb)
        setupFloatingControls()
    }
    
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		activityIndicator.stopAnimating()
	}
	
	
    // MARK: - To configure WebView -
    fileprivate func setupWebView()  {
        webView.scrollView.frame = webView.frame
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
	
		view.addSubviews(webView, activityIndicator)
		
		activityIndicator.centerInSuperview()
        webView.fillSuperview(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
	
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
	
    // MARK: - To setup a floating view to save news of interest and its function -
    fileprivate func setupFloatingControls()    {
        self.view.addSubview(floatingContainerView)
        
        floatingContainerView.centerXInSuperview()
        floatingContainerView.anchor(top: nil, leading: nil, bottom: self.view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: -90, right: 0), size: .init(width: 64, height: 64))
		floatingContainerView.button.addTarget(self, action: #selector(handlePressed), for: .touchUpInside)
    }
    
	
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translationY = -90 - (UIApplication.shared.statusBarUIView?.frame.height ?? 0)
        // Set up a transform variable to decide how the floatingContainerView would be rendered out
        let transform = self.webView.scrollView.contentOffset.y > 300 ? CGAffineTransform(translationX: 0, y: translationY) : .identity
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = transform
        }, completion: nil)
    }
	
	
    // MARK: - To set up operations to write persistent data with Realm
    @objc func handlePressed()   {
        mappingSavedArticle()
        switch self.mode    {
        case .readSavedArticle:
            deleteArticle(title: savedArticle.title)
            navigationController?.popViewController(animated: true)
        case .readUnSavedArticle:
            saveArticle(savedArticle: savedArticle)
        }
    }
    
	
    fileprivate func mappingSavedArticle()  {
        guard let detailNewsChosen = detailedNews else { return }
        savedArticle.title = detailNewsChosen.title ?? ""
        savedArticle.newsDescription = detailNewsChosen.description ?? ""
        savedArticle.url = detailNewsChosen.url
        savedArticle.urlToImage = detailNewsChosen.urlToImage ?? ""
        savedArticle.publishedAt = detailNewsChosen.publishedAt ?? ""
        savedArticle.publisherName = detailNewsChosen.source?.name ?? ""
    }
	
	
    // The function to save the interested article into Realm
    fileprivate func saveArticle(savedArticle: SavedArticle)  {
        do  {
            try realm.write {
                realm.add(savedArticle)
                self.floatingContainerView.isHidden = true
                self.floatingContainerView.isUserInteractionEnabled = false
            }
        }   catch   {
            print("Error saving context, \(error)")
        }
    }
}
