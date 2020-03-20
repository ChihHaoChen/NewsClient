//
//  NewsCardLayout.swift
//  NewsClient
//
//  Created by ChihHao on 2020/02/02.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import Foundation

struct NewsCollectionCellLayout {
	
	static func createCategoryCardLayout(in view: UIView) -> UICollectionViewFlowLayout {
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0)
		flowLayout.itemSize = CGSize(width: view.frame.width, height: UIScreen.main.bounds.width*0.93)
		flowLayout.minimumLineSpacing = 0
		
		return flowLayout
	}
	
	
	static func createSearchCellLayout(in view: UIView) -> UICollectionViewFlowLayout {
		let searchCellLayout = UICollectionViewFlowLayout()
		
		searchCellLayout.itemSize = CGSize(width: view.frame.width-CellSize.minimumSpacingSection, height: CellSize.cellHeight)
		searchCellLayout.minimumLineSpacing = CellSize.minimumSpacingSection
		searchCellLayout.sectionInset = UIEdgeInsets(top: CellSize.minimumSpacingSection/2, left: CellSize.minimumSpacingSection/2, bottom: CellSize.minimumSpacingSection/2, right: CellSize.minimumSpacingSection/2)
		
		return searchCellLayout
	}
}
