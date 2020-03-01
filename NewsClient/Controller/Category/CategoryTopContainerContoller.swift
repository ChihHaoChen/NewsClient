//
//  CategoryTopContainerContoller.swift
//  NewsClient
//
//  Created by ChihHao on 2020/02/27.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTopContainerContoller: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
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
		categoryCollectionView.register(SavedNewsHeaders.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return fetchNewsGroups.count
	}
	
	
    // MARK: - To configure the header, collection cell and their functions -
    fileprivate func pushView(article: Article)->() {
        let detailView = NewsDetailController(mode: self.readingSavedArticle ? .readSavedArticle : .readUnSavedArticle, article: article)
        self.navigationController?.pushViewController(detailView, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
	
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SavedNewsHeaders

        header.savedNewsHorizontalController.collectionView.reloadData()
        header.savedNewsHorizontalController.didSelectHandler = { [weak self] article in
            self?.readingSavedArticle = true
            self?.pushView(article: article)
        }
        return header
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
