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
		flowLayout.headerReferenceSize = CGSize(width: view.frame.width, height: 360)
		
		return flowLayout
	}
}
