//
//  NewsSearchController.swift
//  NewsClient
//
//  Created by chihhao on 2019-06-15.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class NewsSearchController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
	
    fileprivate let cellId = "cellId"
	fileprivate let footerId = "footerId"
    var articleResults = [Article]()
	
    fileprivate let searchLimit: Int =  20
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var searchTerm: String = ""
    fileprivate var searchCount: Int = 0
	
	let noResultsLabel = UILabel(text: "No reults found. \nPlease enter other search words.", font: UIFont.preferredFont(forTextStyle: .callout), numberOfLines: 0, color: .label)
	
    fileprivate var isPaginating = false
    fileprivate var isDonePaginating = false
    
	
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        setupSearchNewsBar()
        setupNoResultsLabel()
    }
    

    fileprivate func configCollectionView() {
		collectionView.backgroundColor = .systemBackground
        collectionView.register(NewsSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(NewsLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        self.isDonePaginating = true
    }
    
	
    fileprivate func setupNoResultsLabel()  {
        collectionView.addSubview(noResultsLabel)
        noResultsLabel.textAlignment = .center
        noResultsLabel.centerXInSuperview()
        noResultsLabel.fillSuperview(padding: .init(top: 32, left: 16, bottom: 16, right: 16))
        noResultsLabel.isHidden = true
//		presentAlertOnMainThread(title: "No results found", message: "Please key in other search terms.", buttonTitle: "I got it!")
    }
    
	
    fileprivate func setupSearchNewsBar()  {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        self.searchController.searchBar.placeholder = "Search News Articles"
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
	
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.isDonePaginating = false
        searchTerm = searchBar.text ?? ""
        articleResults = []
        collectionView.reloadDataOnMainThread()
        self.noResultsLabel.isHidden = true

        fetchAPI(offset: 0)
    }
	
	
    // MARK: - The block to fetch API and operate pagination
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
                self.noResultsLabel.isHidden =
                    (self.articleResults.count == 0 && self.searchCount > 1) ? false: true
				
                self.collectionView.reloadDataOnMainThread()
            }
            self.isPaginating = false
        }
    }
    
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.isDonePaginating = true
		articleResults.removeAll()
		collectionView.reloadDataOnMainThread()
	}
	
	
	// MARK: - UICollectionView Configuration for cells and sizes
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.articleResults.count
    }
    
	
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsSearchCell
        cell.articleResult = self.articleResults[indexPath.item]

        if indexPath.item == self.articleResults.count - 1 && !self.isPaginating && !self.isDonePaginating  {
            self.isPaginating = true
            fetchAPI(offset: self.articleResults.count)
        }

        return cell
    }
    
	
	// MARK: - To configure the collectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightCellFullScreen: CGFloat = (view.frame.height - 6*spacing)/7
        return .init(width: view.frame.width, height: heightCellFullScreen)
    }


    fileprivate let spacing: CGFloat = 12
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)

        return footer
    }
    
	
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = self.isDonePaginating ? 0 : 100
        return .init(width: view.frame.width, height: height)
    }
    
	
    // MARK: - Navigate users to the detailed News page
      override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let detailView = NewsDetailController(mode: .readUnSavedArticle,article: articleResults[indexPath.item])
		self.navigationController?.pushViewController(detailView, animated: true)
		self.tabBarController?.tabBar.isHidden = true
      }
}
