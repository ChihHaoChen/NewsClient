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
        
        let buttonString = (self.mode == .readUnSavedArticle) ? "Save" : "Delete"
        let getButton = UIButton(title: buttonString, titleColor: .red, font: .boldSystemFont(ofSize: 12), width: 64, height: 16, cornerRadius: 16)
        getButton.addTarget(self, action: #selector(handlePressed), for: .touchUpInside)
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
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = transform
        }, completion: nil)
    }
    // MARK: - To set up operations to write persistent data with Realm
    @objc fileprivate func handlePressed()   {
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
    // The function to delete the chosen article from Realm
    fileprivate func deleteArticle(title: String)   {
        
        let predictDeleted = NSPredicate(format: "title = %@", title)
        let chosenToDeleteArticle = realm.objects(SavedArticle.self).filter(predictDeleted)
        do  {
            try self.realm.write {
                self.realm.delete(chosenToDeleteArticle)
            }
        }
        catch   {
            print("Error deleting saved News article, \(error)")
        }
    }
}
