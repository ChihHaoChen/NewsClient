//
//  SavedNewsHeaderCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-28.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class SavedNewsHeaderCell: UICollectionViewCell  {
    var article: SavedArticle! {
        didSet {
            newsTitle.text = article.title
            publishedAt.text = "\(article.publisherName) • \(article.publishedAt.prefix(10))"
			newsImageView.sd_setImage(with: URL(string: article.urlToImage), placeholderImage: ConfigEnv.placeHolder)
        }
    }
	let newsTitle = UILabel(text: " ", font: UIFont.preferredFont(forTextStyle: .body), numberOfLines: 2, color: .label)
	let publishedAt = UILabel(text: " ", font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 1, color: .label)
	let newsImageView = UIImageView(cornerRadius: CellSize.imageCornerRadius)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
		newsImageView.constrainHeight(constant: self.frame.width/1.67)
		newsImageView.layer.borderWidth = 2
		newsImageView.layer.borderColor = UIColor.systemGray.cgColor
        let vstack = VerticalStackView(arrangedSubviews: [newsImageView, newsTitle, publishedAt], spacing: 4)
        addSubview(vstack)
        vstack.fillSuperview(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        publishedAt.textColor = .secondaryLabel
		publishedAt.textAlignment = .right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
