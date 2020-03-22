//
//  NewsSearchViewController.swift
//  NewsClient
//
//  Created by ChihHao on 2020/03/03.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit

class NewsSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

	var searchCollectionView: UICollectionView!
	let activityIndicator = UIActivityIndicatorView(color: .systemGray, style: .large)
	var articleResults = [Article]()
	
	fileprivate var isPaginating = false
	fileprivate var isDonePaginating = false
	fileprivate let cellId = "cellId"
	fileprivate let footerId = "footerId"
	
	fileprivate let searchLimit: Int =  20
	fileprivate let searchController = UISearchController(searchResultsController: nil).searchBar
	fileprivate var searchTerm: String = ""
	fileprivate var searchCount: Int = 0
	
	let noResultsLabel = UILabel(text: "No reults found. \nPlease enter other search words.", font: UIFont.preferredFont(forTextStyle: .callout), numberOfLines: 0, color: .label)
	let titleLabel = UILabel(text: "Search", font: UIFont.preferredFont(forTextStyle: .largeTitle).bold(), numberOfLines: 1, color: .label)
	
	override func viewDidLoad() {
		super.viewDidLoad()

        configureSearchCollectionView()
		configureUIElements()
		configureSearchNewsBar()
		setupNoResultsLabel()
    }
    

	// MARK: - To configure UI elements
	func configureUIElements() {
		titleLabel.textAlignment = .center
		
		view.addSubviews(titleLabel, searchController, searchCollectionView, activityIndicator)
		activityIndicator.fillSuperview()
		activityIndicator.stopAnimating()
		
		anchorUIElements()
	}
	
	
	func anchorUIElements() {
		titleLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 60, left: 8, bottom: 0, right: 8), size: .init(width: view.frame.width-16, height: 40))
		
		searchController.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width, height: 40))
		
		searchCollectionView.anchor(top: searchController.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 8, right: 0))
	}
	
    // MARK: - TO configure searchCollectionView
	func configureSearchCollectionView() {
		searchCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: NewsCollectionCellLayout.createSearchCellLayout(in: view))
		searchCollectionView.backgroundColor = .systemBackground
		
		searchCollectionView.delegate = self
		searchCollectionView.dataSource = self
		
		searchCollectionView.register(NewsSearchCell.self, forCellWithReuseIdentifier: cellId)
		searchCollectionView.register(NewsLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
		
		isDonePaginating = true
	}
	
	
	// MARK: - To configure searchBar
	fileprivate func configureSearchNewsBar()	{
		definesPresentationContext = true
		
		searchController.backgroundColor = .systemBackground
		searchController.searchBarStyle = .minimal
		searchController.placeholder = "Search News Articles"
		searchController.delegate = self

//		searchController.obscuresBackgroundDuringPresentation = false
	}
	
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		isDonePaginating = false
		noResultsLabel.isHidden = true
		
		searchTerm = searchBar.text ?? ""
		articleResults = []
		
		searchBar.endEditing(true)
		searchCount = 0
		
		fetchAPI(offset: 0)
		
		activityIndicator.startAnimating()
		
		searchCollectionView.reloadDataOnMainThread()
	}
	
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchCount = 0
		isDonePaginating = true
		articleResults.removeAll()
		activityIndicator.stopAnimating()
		searchCollectionView.reloadDataOnMainThread()
	}
	
	
	// MARK: - To configure the searchCells and footer
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return articleResults.count
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsSearchCell
		cell.articleResult = articleResults[indexPath.item]
		
		if indexPath.item == articleResults.count - 1 && !isPaginating && !isDonePaginating  {
            isPaginating = true
            fetchAPI(offset: articleResults.count)
        }
		
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let detailView = NewsDetailController(mode: .readUnSavedArticle,article: articleResults[indexPath.item])
		searchController.endEditing(true)
		navigationController?.pushViewController(detailView, animated: true)
		tabBarController?.tabBar.isHidden = true
	}
	
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let footer = searchCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
		
		return footer
	}
	
	
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		let height: CGFloat = isDonePaginating ? 0 : CellSize.cellHeight
        return .init(width: view.frame.width, height: height)
    }
	
	
	// MARK: - To configure noResultsLabel
	fileprivate func setupNoResultsLabel() {
		searchCollectionView.addSubview(noResultsLabel)
		
		noResultsLabel.textAlignment = .center
		noResultsLabel.centerInSuperview()
		noResultsLabel.fillSuperview(padding: .init(top: 32, left: 16, bottom: 16, right: 16))
		noResultsLabel.isHidden = true
	}
	
	
	// MARK: - To fetch API and perform pagination
	fileprivate func fetchAPI(offset: Int) {
        self.searchCount += 1
		
        Service.shared.fetchNewsSearch(page: offset, limit: searchLimit, search: searchTerm.replacingOccurrences(of: " ", with: "")) { (result: newsGroup?, error) in
            if let error = error {
                print("Failed to paginate data: ", error)
                return
            }
            let count: Int = (result?.articles.count)!
			self.isDonePaginating = (count == 0) || (count % self.searchLimit != 0)  ? true : false

            sleep(1)
            self.articleResults += result?.articles ?? []
           
            DispatchQueue.main.async {
				if self.articleResults.count == 0 && self.searchCount == 1 {
					self.presentAlert(title: "No Found Results", message: "Please enter other search words.", buttonTitle: "Gotcha!")
				}
				
				self.activityIndicator.stopAnimating()
				self.searchCollectionView.reloadData()
            }
			
			self.isPaginating = false
		}
	}
}
