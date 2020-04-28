//
//  CategoryContoller.swift
//  NewsClient
//
//  Created by ChihHao on 2020/02/27.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit

class CategoryContoller: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
    let cellId: String = "cellId"

	var categoryCollectionView: UICollectionView!
	let activityIndicator = UIActivityIndicatorView(color: .systemGray, style: .large)
	
	var fetchNewsGroups = [categoryGroup]()
    var categoryArray = ["business", "technology", "science", "health", "sports", "entertainment"]
	
	var readingSavedArticle: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureCategoryCollectionView()
		configureUIElements()
		fetchData()
		
		pullToRefresh()
    }
	
		
	// MARK: - TO configure all the UI elements
	func configureUIElements() {
		view.addSubviews(categoryCollectionView, activityIndicator)
		activityIndicator.fillSuperview()
	}
	
	
	func configureCategoryCollectionView() {
		
		categoryCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: NewsCollectionCellLayout.createCategoryCardLayout(in: view))
		
		categoryCollectionView.backgroundColor = .systemBackground
		
		categoryCollectionView.delegate = self
		categoryCollectionView.dataSource = self
		
		categoryCollectionView.register(TitleCellCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCellCollectionView.headerId)
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
	
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleCellCollectionView.headerId, for: indexPath) as! TitleCellCollectionView
		
		header.titleLabel.text = "Categories"
		
		return header
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return fetchNewsGroups.count
	}
	
	
	// MARK: - To enable the feature of pulling to refresh content -
	fileprivate func pullToRefresh() {
		let refreshControl = UIRefreshControl()
		refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh News")
		refreshControl.addTarget(self, action: #selector(refreshFetch), for: .valueChanged)
		
		categoryCollectionView.addSubview(refreshControl)
	}
	
	
	@objc func refreshFetch(refreshControl: UIRefreshControl) {
		activityIndicator.startAnimating()
		
		fetchData()
		
		refreshControl.endRefreshing()
		
		presentAlert(title: "Update Is Done", message: "All the categories are updated completely.", buttonTitle: "Gotcha!")
	}
	
	
	// MARK: - Function to fetch data from News API -
	fileprivate func fetchData()   {
		
		var newsCategories = [categoryGroup?]()
		// To sync fetch API requests
		let dispatchGroup = DispatchGroup()
		newsCategories.removeAll()
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
		fetchNewsGroups.removeAll()
		categoryCollectionView.reloadData()
		
		dispatchGroup.notify(queue: .main) {
			newsCategories.forEach { (group) in
				guard let newsGroup = group else { return }
				self.fetchNewsGroups.append(newsGroup)
			}
			self.fetchNewsGroups = self.fetchNewsGroups.sorted { $0.category < $1.category }
			self.categoryCollectionView.reloadData()
		}
		activityIndicator.stopAnimating()
	}
}
