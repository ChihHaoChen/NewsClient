//
//  NewsHorizontalController.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-25.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class NewsHorizontalController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout    {
    fileprivate let cellId = "horizontalCell"
    var newsGroup: newsGroup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(NewsRowCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .white

        collectionView.contentInset = .init(top: 0, left: 12, bottom: 0, right: 12)
    }
    // MARK: -- Configure the cells and their functions for the controller
    var didSelectHandler: ((Article)->())?
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let article = newsGroup?.articles[indexPath.item] {
            didSelectHandler?(article)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsGroup?.articles.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsRowCell
        
        let article = newsGroup?.articles[indexPath.item]
        cell.titleLabel.text = article?.title
        cell.publisherLabel.text = article?.source?.name
        cell.newsRowIcon.sd_setImage(with: URL(string: article?.urlToImage ?? ""))
        
        return cell
    }
    // MARK: -- Cell layout settings inside HorizontalController
    let topBottomPadding: CGFloat = 12
    let linespacing: CGFloat = 10
    let rightLeftPadding: CGFloat = 12
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.height - 2*topBottomPadding - 2*linespacing)/3
        return .init(width: view.frame.width-32, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: topBottomPadding, left: 0, bottom: topBottomPadding, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return linespacing
    }
}
