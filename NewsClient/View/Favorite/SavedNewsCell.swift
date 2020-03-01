//
//  SavedNewsCell.swift
//  NewsClient
//
//  Created by ChihHao on 2020/03/01.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit

class SavedNewsCell: UITableViewCell {

	static let cellId = "savedNewsCell"
	
	let newsImageView = UIImageView(cornerRadius: 12)
	let nameLabel = UILabel(text: "News Title", font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 3, color: .label)
	let descriptionLabel = UILabel(text: "Author Label", font: UIFont.preferredFont(forTextStyle: .body), numberOfLines: 1, color: .label)
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }()

	var articleResult: SavedArticle!   {
        didSet  {
            nameLabel.text = articleResult.title
            newsImageView.sd_setImage(with: URL(string: articleResult.urlToImage), placeholderImage: UIImage(named: "News_iOS_Icon"))
            descriptionLabel.text = "\(articleResult.publisherName) • \(articleResult.publishedAt.prefix(10))"
        }
    }
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	private func configure() {
		newsImageView.image = #imageLiteral(resourceName: "News_iOS_Icon")
        newsImageView.clipsToBounds = true
        newsImageView.constrainWidth(constant: self.frame.width/2.5 )
        newsImageView.constrainHeight(constant: self.frame.width/4)
        
        let stackView = UIStackView(arrangedSubviews: [
            newsImageView,
            VerticalStackView(arrangedSubviews: [nameLabel, descriptionLabel], spacing: 4)
            ], customSpacing: 4)
		
		addSubviews(stackView, separator)
		
		stackView.spacing = 12.8*(ScreenSize.width/320)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center

        separator.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 0.5))
	}
}
