//
//  TodayWorldwideHeaderCell.swift
//  NewsClient
//
//  Created by ChihHao on 2020/02/10.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit

class TodayWorldwideHeaderCell: UICollectionViewCell {
	
	let worldwideNewsLabel = UILabel(text: "Worldwide Top News", font: UIFont.preferredFont(forTextStyle: .largeTitle).bold(), numberOfLines: 1, color: .label)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(worldwideNewsLabel)
		worldwideNewsLabel.fillSuperview(padding: .init(top: 16, left: 8, bottom: 8, right: 8))
		backgroundColor = .systemBackground
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
