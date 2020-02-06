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
		let padding: CGFloat = 8
		let itemWidth: CGFloat = view.frame.width - 2*padding
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
		flowLayout.itemSize = CGSize(width: itemWidth, height: 560)
		
		return flowLayout
	}
}
