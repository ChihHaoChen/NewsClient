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
            newsImageView.sd_setImage(with: URL(string: article.urlToImage), placeholderImage: UIImage(named: "News_iOS_Icon"))
        }
    }
	let newsTitle = UILabel(text: " ", font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 2, color: .label)
	let publishedAt = UILabel(text: " ", font: UIFont.preferredFont(forTextStyle: .body), numberOfLines: 1, color: .label)
    let newsImageView = UIImageView(cornerRadius: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        newsImageView.constrainHeight(constant: self.frame.width/2)
        let vstack = VerticalStackView(arrangedSubviews: [newsImageView, newsTitle, publishedAt], spacing: 4)
        addSubview(vstack)
        vstack.fillSuperview(padding: .init(top: 12, left: 0, bottom: 0, right: 0))
        publishedAt.textColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
