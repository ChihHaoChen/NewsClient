//
//  CategoryController.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-25.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class CategoryController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout  {
    let headerId: String = "headerId"
    let cellId: String = "cellId"
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()

    var fetchNewsGroups = [categoryGroup]()
    var categoryArray = ["business", "technology", "science", "health", "sports", "entertainment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        fetchData()
    }
    
    // MARK: - To configure the UICollectionView with activity indicator
    fileprivate func configCollectionView()  {
        self.navigationController?.navigationBar.isHidden = true
                collectionView.backgroundColor = .white
                collectionView.register(NewsGroupCell.self, forCellWithReuseIdentifier: cellId)
        //        collectionView.register(NewsPageHeaders.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
    }
    
    // MARK: - Function to fetch data from News API -
    
    fileprivate func fetchData()   {

        var newsCategories = [categoryGroup?]()
//        var featuredGroup: [SocialApp]?

        // To sync fetch API requests
        let dispatchGroup = DispatchGroup()

        
        categoryArray.forEach { (type) in
            dispatchGroup.enter()
            Service.shared.fetchCategoryNews(type: type)   { (articlesGroup, error) in
                if error != nil {
                   print("API Fetch Error ->", error!)
                   return
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
            print("number is \(newsCategories.count)")
            self.activityIndicatorView.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - To configure the collection cell and its funcation -
    fileprivate func pushView(url: String)->() {
        let detailView = NewsDetailController(url: url)
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
            self?.pushView(url: article.url)
        }
        return cell
    }
    // MARK: - To set up the layout of the collection sections -
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchNewsGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.view.frame.width, height: self.view.frame.width*0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
}
