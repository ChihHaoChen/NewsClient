//
//  CategoryController.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-25.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate  {
    let realm = try! Realm()
    let headerId: String = "headerId"
    let cellId: String = "cellId"
    var readingSavedArticle: Bool = false
	let cellPadding: CGFloat = 8
    let activityIndicatorView: UIActivityIndicatorView = {
		let aiv = UIActivityIndicatorView(style: .large)
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()

    var fetchNewsGroups = [categoryGroup]()
    var savedNews: Results<SavedArticle>?
    var categoryArray = ["business", "technology", "science", "health", "sports", "entertainment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        configCollectionView()
        fetchData()
    }
    // MARK: - To update the header cell after adding or removing saved articles
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        savedNews = realm.objects(SavedArticle.self)
        // reloadData will reload all the sections including header.
        self.collectionView.reloadData()
    }
    
    // MARK: - To configure the UICollectionView with activity indicator
    fileprivate func configCollectionView()  {
        self.navigationController?.navigationBar.isHidden = true
		collectionView.backgroundColor = .systemBackground
		collectionView.register(NewsGroupCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(SavedNewsHeaders.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
    }
    
    // MARK: - Function to fetch data from News API -
    fileprivate func fetchData()   {

        var newsCategories = [categoryGroup?]()
        // To sync fetch API requests
        let dispatchGroup = DispatchGroup()

        print("Fetch oncesr")
        categoryArray.forEach { (type) in
            dispatchGroup.enter()
            Service.shared.fetchCategoryNews(type: type)   { (articlesGroup, error) in
                if error != nil {
					print("Error Message")
                }
                guard let articlesGroupFetched = articlesGroup else { return }
                let groupFetched = categoryGroup(category: type, newsGroup: articlesGroupFetched)
                newsCategories.append(groupFetched)
                dispatchGroup.leave()
            }
        }
        
        // Completion
        dispatchGroup.notify(queue: .main) {
            newsCategories.forEach { (group) in
                guard let newsGroup = group else { return }
                self.fetchNewsGroups.append(newsGroup)
            }
            self.activityIndicatorView.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - To configure the header, collection cell and their functions -
    fileprivate func pushView(article: Article)->() {
        let detailView = NewsDetailController(mode: self.readingSavedArticle ? .readSavedArticle : .readUnSavedArticle, article: article)
        self.navigationController?.pushViewController(detailView, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsGroupCell

        let group = fetchNewsGroups[indexPath.item]
        cell.titleLabel.text = group.category.capitalizingFirstLetter()
        cell.horizontalController.newsGroup = group.newsGroup
        // Very important to reload the data into cells after fetching API results
        cell.horizontalController.collectionView.reloadData()
        cell.horizontalController.didSelectHandler = { [weak self] article in
            self?.readingSavedArticle = false
            self?.pushView(article: article)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SavedNewsHeaders
        
        header.savedNewsHorizontalController.collectionView.reloadData()
        header.savedNewsHorizontalController.didSelectHandler = { [weak self] article in
            self?.readingSavedArticle = true
            self?.pushView(article: article)
        }
        return header
    }
    
    // MARK: - To set up the layout of the collection sections -
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchNewsGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.view.frame.width, height: self.view.frame.width*0.93)
    }
    
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}
