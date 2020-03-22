//
//  NewsRowCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-25.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class NewsRowCell: UICollectionViewCell    {
    var article: Article! {
        didSet  {
            publisherLabel.text = article.source?.name
            titleLabel.text = article.title
			newsRowIcon.sd_setImage(with: URL(string: article.urlToImage ?? ""), placeholderImage: ConfigEnv.placeHolder)
        }
    }
    let newsRowIcon = UIImageView(cornerRadius: 12)
	let titleLabel = UILabel(text: "News Title", font: UIFont.preferredFont(forTextStyle: .body), numberOfLines: 3, color: .label)
	let publisherLabel = UILabel(text: "Publisher", font: UIFont.preferredFont(forTextStyle: .caption1), numberOfLines: 1, color: .secondaryLabel)
	let cellPadding: CGFloat = 8
    let separator: UIView = {
        let view = UIView()
		view.backgroundColor = .separator
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
		backgroundColor = .systemGroupedBackground
        // By the UIView+Layout helper
		newsRowIcon.constrainWidth(constant: self.frame.width/3.3)
		newsRowIcon.constrainHeight(constant: self.frame.width/4.1)
        newsRowIcon.layer.borderWidth = 2
		newsRowIcon.layer.borderColor = UIColor.systemGray.cgColor
        let stackView = UIStackView(arrangedSubviews: [newsRowIcon, VerticalStackView(arrangedSubviews: [titleLabel, publisherLabel], spacing: 8)])
		publisherLabel.textAlignment = .right
        stackView.spacing = 8
        stackView.alignment = .center
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 0, bottom: 0, right: cellPadding))
        addSubview(separator)
        separator.anchor(top: nil, leading: titleLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 1))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
