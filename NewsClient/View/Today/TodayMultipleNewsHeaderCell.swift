//
//  TodayMultipleNewsHeaderCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-10-16.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class TodayMultipleNewsHeaderCell: UICollectionViewCell {
	let categoryLabel = UILabel(text: "Top News", font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 1, color: .label)
	let titleLabel = UILabel(text: " ", font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 1, color: .label)
    override init(frame: CGRect) {
        super.init(frame: frame)
        let vstack = VerticalStackView(arrangedSubviews: [
            titleLabel,
            categoryLabel
            ], spacing: 8)
        addSubview(vstack)
        vstack.fillSuperview(padding: .init(top: 20, left: 16, bottom: 8, right: 16))
		backgroundColor = .systemGroupedBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
