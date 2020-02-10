//
//  NewsCardLayout.swift
//  NewsClient
//
//  Created by ChihHao on 2020/02/02.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import Foundation

struct NewsCardLayout {
	
	static func createNewsCardLayout(in view: UIView) -> UICollectionViewFlowLayout {
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
		flowLayout.itemSize = CGSize(width: view.frame.width - 16, height: UIScreen.main.bounds.width*1.33)
		flowLayout.minimumLineSpacing = 16
		
		return flowLayout
	}
}
