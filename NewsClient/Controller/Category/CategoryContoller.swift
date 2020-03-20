//
//  CategoryContoller.swift
//  NewsClient
//
//  Created by ChihHao on 2020/02/27.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryContoller: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	let realm = try! Realm()
	
	let headerId: String = "headerId"
    let cellId: String = "cellId"

	var categoryCollectionView: UICollectionView!
	let activityIndicator = UIActivityIndicatorView(color: .systemGray, style: .large)
	
	var fetchNewsGroups = [categoryGroup]()
    var savedNews: Results<SavedArticle>?
    var categoryArray = ["business", "technology", "science", "health", "sports", "entertainment"]
	
	var readingSavedArticle: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureCategoryCollectionView()
		configureUIElements()
		fetchData()
    }
	
	
	// MARK: - To update the header cell after adding or removing saved articles
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		savedNews = realm.objects(SavedArticle.self)
        // reloadData will reload all the sections including header.
        categoryCollectionView.reloadData()
	}
	
	
	// MARK: - TO configure all the UI elements
	func configureUIElements() {
		self.navigationController?.navigationBar.isHidden = true
		view.addSubviews(categoryCollectionView, activityIndicator)
		activityIndicator.fillSuperview()
	}
	
	
	func configureCategoryCollectionView() {
		
		categoryCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: NewsCardLayout.createCategoryCardLayout(in: view))
		
		categoryCollectionView.backgroundColor = .systemBackground
		
		categoryCollectionView.delegate = self
		categoryCollectionView.dataSource = self
		
		categoryCollectionView.register(NewsGroupCell.self, forCellWithReuseIdentifier: cellId)
	}
	
	
    // MARK: - To configure the navigation, and hide tabBar
    fileprivate func pushView(article: Article)->() {
        let detailView = NewsDetailController(mode: self.readingSavedArticle ? .readSavedArticle : .readUnSavedArticle, article: article)
        self.navigationController?.pushViewController(detailView, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return fetchNewsGroups.count
	}
	
	
	// MARK: - Function to fetch data from News API -
	fileprivate func fetchData()   {
		
		var newsCategories = [categoryGroup?]()
		// To sync fetch API requests
		let dispatchGroup = DispatchGroup()
		
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
			self.activityIndicator.stopAnimating()
			self.categoryCollectionView.reloadData()
		}
	}
}
