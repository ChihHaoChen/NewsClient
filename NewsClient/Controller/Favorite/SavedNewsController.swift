//
//  SavedNewsController.swift
//  NewsClient
//
//  Created by ChihHao on 2020/03/01.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit
import RealmSwift

class SavedNewsController: UIViewController {
	
	let savedNewsTable = UITableView()
	let realm = try! Realm()
	
	var savedNews: Results<SavedArticle>?
	var didSelectHandler: ((Article)->())?
	
	let readingSavedArticle = true
	fileprivate let spacing: CGFloat = 12
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureViewController()
		loadSavedArticles()
    }
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		savedNews = realm.objects(SavedArticle.self)
		
		savedNewsTable.reloadDataOnMainThread()
	}

	
	// MARK: - Configure the whole UI and the tableView
	func configureViewController() {
		view.backgroundColor = .systemBackground
		title = "Saved News"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		configureTableView()
	}
	
	
	func configureTableView() {
		view.addSubview(savedNewsTable)
		savedNewsTable.frame = view.bounds
		savedNewsTable.rowHeight = (view.frame.height - 6*spacing)/7
		savedNewsTable.separatorStyle = .none
		
		savedNewsTable.delegate = self
		savedNewsTable.dataSource = self
		
		savedNewsTable.register(SavedNewsCell.self, forCellReuseIdentifier: SavedNewsCell.cellId)
		savedNewsTable.removeExcessCells()
		
	}
	
	
    fileprivate func loadSavedArticles()    {
        savedNews = realm.objects(SavedArticle.self)
    }
}


extension SavedNewsController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return savedNews?.count ?? 0
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = savedNewsTable.dequeueReusableCell(withIdentifier: SavedNewsCell.cellId, for: indexPath) as! SavedNewsCell
		if let savedArticle = savedNews?[indexPath.row] {
			cell.articleResult = savedArticle
		}
		
		return cell
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let selectedSavedNews = savedNews?[indexPath.row] else { return }
		
		let selectedArticle = Article(source: nil, title: selectedSavedNews.title, description: selectedSavedNews.description, url: selectedSavedNews.url, urlToImage: selectedSavedNews.urlToImage, publishedAt: selectedSavedNews.publishedAt, content: nil)
		
		let detailView = NewsDetailController(mode: self.readingSavedArticle ? .readSavedArticle : .readUnSavedArticle, article: selectedArticle)
        self.navigationController?.pushViewController(detailView, animated: true)
        self.tabBarController?.tabBar.isHidden = true
		
		tableView.reloadDataOnMainThread()
	}
	
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		guard let selectedSavedNews = savedNews?[indexPath.row] else { return }
		
		deleteArticle(title: selectedSavedNews.title)
		savedNewsTable.reloadDataOnMainThread()
	}
}
