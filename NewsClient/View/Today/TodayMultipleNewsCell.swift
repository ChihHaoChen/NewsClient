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
    let screenWidth = UIScreen.main.bounds.width
    let newsRowIcon = UIImageView(cornerRadius: 12)
	let titleLabel = UILabel(text: "News Name", font: UIFont.preferredFont(forTextStyle: .body), numberOfLines: 3, color: .label)
	let nameLabel = UILabel(text: "Publisher Name", font: UIFont.preferredFont(forTextStyle: .caption1), numberOfLines: 1, color: .secondaryLabel)
    
    let separator: UIView = {
        let view = UIView()
		view.backgroundColor = .separator
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
		backgroundColor = .systemGroupedBackground
		newsRowIcon.constrainWidth(constant: frame.width/3.3)
		newsRowIcon.constrainHeight(constant: frame.width/4.1)
		newsRowIcon.layer.borderWidth = 2
		newsRowIcon.layer.borderColor = UIColor.systemGray.cgColor
		nameLabel.textAlignment = .right
        let stackView = UIStackView(arrangedSubviews: [newsRowIcon, VerticalStackView(arrangedSubviews: [titleLabel, nameLabel], spacing: 4)])
        stackView.spacing = 12
        stackView.alignment = .center
        addSubview(stackView)
        stackView.fillSuperview()
        
        addSubview(separator)
        separator.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 1))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
