//
//  NewsGroupCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-25.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class NewsGroupCell: UICollectionViewCell   {
	let titleLabel = UILabel(text: "News Selection", font: UIFont.preferredFont(forTextStyle: .largeTitle).bold(), numberOfLines: 1, color: .label)
    let horizontalController = NewsHorizontalController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
		backgroundColor = .systemBackground
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 0))
        addSubview(horizontalController.view)
		horizontalController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 8, bottom: 8, right: 8))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//
