//
//  NewsCardLayout.swift
//  NewsClient
//
//  Created by ChihHao on 2020/02/02.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import Foundation

struct NewsCardLayout {
	
	static func createCategoryCardLayout(in view: UIView) -> UICollectionViewFlowLayout {
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0)
		flowLayout.itemSize = CGSize(width: view.frame.width, height: UIScreen.main.bounds.width*0.93)
		flowLayout.minimumLineSpacing = 0
		
		return flowLayout
	}
	
	
	static func createSearchCellLayout(in view: UIView) -> UICollectionViewFlowLayout {
		let spacing: CGFloat = 12
		let searchCellLayout = UICollectionViewFlowLayout()
		
		searchCellLayout.itemSize = CGSize(width: view.frame.width, height: (view.frame.height - 6*spacing)/7)
		searchCellLayout.minimumLineSpacing = spacing
		searchCellLayout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
		
		return searchCellLayout
	}
}
