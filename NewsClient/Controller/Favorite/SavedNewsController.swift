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
	fileprivate let headerId = "headerId"
	
	let savedNewsTable = UITableView(frame: UIScreen.main.bounds, style: UITableView.Style.grouped)
	let realm = try! Realm()
	
	var savedNews: Results<SavedArticle>?
	var didSelectHandler: ((Article)->())?
	
	let readingSavedArticle = true
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureViewController()
		loadSavedArticles()
    }
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		savedNews = realm.objects(SavedArticle.self)
		
		savedNewsTable.reloadDataOnMainThread()
		alertWhenNoSavedArticles()
	}

	
	// MARK: - Configure the whole UI and the tableView
	func configureViewController() {
		view.backgroundColor = .systemBackground
		
		configureTableView()
	}
	
	
	func configureTableView() {
		view.addSubview(savedNewsTable)
		
		savedNewsTable.frame = view.bounds
		savedNewsTable.rowHeight = CellSize.cellHeight + CellSize.minimumSpacingSection
		
		savedNewsTable.backgroundColor = .systemBackground
		
		savedNewsTable.separatorStyle = .none
		
		savedNewsTable.delegate = self
		savedNewsTable.dataSource = self
		
		savedNewsTable.register(SavedNewsCell.self, forCellReuseIdentifier: SavedNewsCell.cellId)
		savedNewsTable.register(TitleCellTableView.self, forHeaderFooterViewReuseIdentifier: TitleCellTableView.reuseIdentifier)
		
		savedNewsTable.removeExcessCells()
		
	}
	
	
    fileprivate func loadSavedArticles()    {
        savedNews = realm.objects(SavedArticle.self)
    }
	
	
	fileprivate func alertWhenNoSavedArticles() {
		if savedNews?.isEmpty ?? true {
			presentAlertOnMainThread(title: "No Saved News", message: "Add the news article you'd like to read/collect.", buttonTitle: "Gotcha!")
			
			let message = "Pin the articles that you're interested \n by pressing"
			
			DispatchQueue.main.async {
				self.showEmptySavedArticles(with: message, in: self.view)
			}
			
			return
		}
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
	
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let headerView = savedNewsTable.dequeueReusableHeaderFooterView(withIdentifier: TitleCellTableView.reuseIdentifier) as? TitleCellTableView else { return nil }
		
		headerView.titleLabel.text = "Favorites"
		
		
		return headerView
	}

	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return ConfigEnv.heightHeaderCell
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
	
	
	func showEmptySavedArticles(with message: String, in view: UIView) {
		let emptyArticlesView = EmptySavedNewsView(message: message)
		
		emptyArticlesView.frame = view.bounds
		view.addSubview(emptyArticlesView)
	}
}
