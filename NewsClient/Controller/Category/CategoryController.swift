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

    var fetchNewsGroups = [newsGroup]()
    var categoryArray = ["business", "technology", "science", "health", "sport"]
    
//    var socialApps = [SocialApp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(NewsGroupCell.self, forCellWithReuseIdentifier: cellId)
//        collectionView.register(NewsPageHeaders.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        
        fetchData()
    }
    
    fileprivate func fetchData()   {

        var newsCategories = [newsGroup?]()
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
                newsCategories.append(articlesGroup)
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

    fileprivate func pushView(url: String)->() {
        let detailView = NewsDetailController(url: url)
        self.navigationController?.pushViewController(detailView, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsGroupCell

        let group = fetchNewsGroups[indexPath.item]
        cell.titleLabel.text = "CategoryType"
        cell.horizontalController.newsGroup = group
        // Very important to reload the data into cells after fetching API results
        cell.horizontalController.collectionView.reloadData()
        cell.horizontalController.didSelectHandler = { [weak self] article in
            self?.pushView(url: article.url)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchNewsGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.view.frame.width, height: self.view.frame.width*0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
}
