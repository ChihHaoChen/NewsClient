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
        configureCollectionViewOutlook()
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
        cell.article = newsGroup?.articles[indexPath.item]
		if(indexPath.item % 3 == 2)  {
            cell.separator.alpha = 0
        }
        return cell
    }
	
	func configureCollectionViewOutlook()	{
		collectionView.backgroundColor = .systemGroupedBackground
        collectionView.contentInset = .init(top: 0, left: 12, bottom: 0, right: 12)
		collectionView.layer.borderWidth = 2
		collectionView.layer.borderColor = UIColor.systemGray4.cgColor
		collectionView.layer.cornerRadius = 12
	}
    // MARK: -- Cell layout settings inside HorizontalController
    let topBottomPadding: CGFloat = 12
	let linespacing: CGFloat = 12
    let rightLeftPadding: CGFloat = 8
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.height - 2*topBottomPadding - 2*linespacing)/3
        return .init(width: view.frame.width-32, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: topBottomPadding, left: 0, bottom: topBottomPadding, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
