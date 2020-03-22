//
//  TitleCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-10-16.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class TitleCellCollectionView: UICollectionViewCell {
	static let headerId = "headerId"
	let titleLabel = UILabel(text: "Title", font: UIFont.preferredFont(forTextStyle: .largeTitle).bold(), numberOfLines: 1, color: .label)
	
	override init(frame: CGRect) {
		super.init(frame: frame)

		backgroundColor = .systemBackground
		
        addSubview(titleLabel)
		
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 8, bottom: 16, right: 0))
		titleLabel.textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
