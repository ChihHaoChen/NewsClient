//
//  TitleCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-10-16.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class TitleCell: UICollectionViewCell {
	let todayLabel = UILabel(text: "Today", font: UIFont.preferredFont(forTextStyle: .largeTitle), numberOfLines: 1, color: .label)
    override init(frame: CGRect) {
        super.init(frame: frame)
		backgroundColor = .systemBackground
        addSubview(todayLabel)
        todayLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
