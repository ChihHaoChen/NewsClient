//
//  SavedNewsHeaderHorizontalController.swift
//  NewsClientJson
//
//  Created by chihhao on 2019-04-28.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit
import RealmSwift

class SavedNewsHeaderHorizontalController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout  {
	
    fileprivate let cellId = "headerCellId"
	fileprivate let emptyCellId = "emptyCellId"
    let realm = try! Realm()
    
    var savedNews: Results<SavedArticle>?
    var didSelectHandler: ((Article)->())?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(SavedNewsHeaderCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(SavedNewsHeaderEmptyCell.self, forCellWithReuseIdentifier: emptyCellId)
		
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = .init(top: 0, left: 12, bottom: 0, right: 12)
        loadSavedArticles()
    }
	
	
    // MARK: - To load the savedArticles saved in Realm
    fileprivate func loadSavedArticles()    {
        savedNews = realm.objects(SavedArticle.self)
    }
    
	
    // MARK: - To configure the cllectionView for the top saved news -
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if savedNews?.isEmpty ?? false {
			return 1
		}

		return savedNews?.count ?? 0
    }

	
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
		if savedNews?.isEmpty ?? false {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellId, for: indexPath) as! SavedNewsHeaderEmptyCell
			
			return cell
		}
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SavedNewsHeaderCell
		if let article = savedNews?[indexPath.item]    {
			cell.article = article
		}
        return cell
    }

	
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width-48, height: collectionView.frame.height)
    }

	
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if savedNews?.isEmpty ?? false {
				print("Empty Articled clicked")
			return
		}
		
        guard let chosenSavedNews = savedNews?[indexPath.item] else { return }
        let savedArticle = Article(source: nil, title: chosenSavedNews.title, description: chosenSavedNews.newsDescription, url: chosenSavedNews.url, urlToImage: chosenSavedNews.urlToImage, publishedAt: chosenSavedNews.publishedAt, content: nil)

        didSelectHandler?(savedArticle)
    }
}


