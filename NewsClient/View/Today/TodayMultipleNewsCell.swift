//
//  MultipleAppCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-06-03.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class TodayMultipleNewsCell: UICollectionViewCell {
	
    var article: Article! {
        didSet  {
            nameLabel.text = article.source?.name
            titleLabel.text = article.title
            newsRowIcon.sd_setImage(with: URL(string: article.urlToImage ?? ""), placeholderImage: UIImage(named: "News_iOS_Icon"))
        }
    }
	
	let newsRowIcon = UIImageView(cornerRadius: CellSize.imageCornerRadius)
	let titleLabel = UILabel(text: "News Name", font: UIFont.preferredFont(forTextStyle: .body), numberOfLines: CellSize.titleNumberOfLines, color: .label)
	let nameLabel = UILabel(text: "Publisher Name", font: UIFont.preferredFont(forTextStyle: .caption1), numberOfLines: 1, color: .secondaryLabel)
    
    let separator = SeparatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
		backgroundColor = .systemGroupedBackground
		newsRowIcon.clipsToBounds = true
		newsRowIcon.constrainWidth(constant: CellSize.imageWidth)
		newsRowIcon.constrainHeight(constant: CellSize.imageHeight)
		newsRowIcon.layer.borderWidth = CellSize.cellBorderWidth
		newsRowIcon.layer.borderColor = UIColor.systemGray.cgColor
		
		nameLabel.textAlignment = .right
		
        let stackView = UIStackView(arrangedSubviews: [newsRowIcon, VerticalStackView(arrangedSubviews: [titleLabel, nameLabel], spacing: 4)])
		stackView.spacing = CellSize.spacingImage2Content
        stackView.alignment = .center
		
        addSubviews(stackView, separator)
        stackView.fillSuperview()
        
		separator.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: CellSize.separatorPaddingfromBootm, right: 0), size: .init(width: 0, height: CellSize.separatorLineWidth))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
