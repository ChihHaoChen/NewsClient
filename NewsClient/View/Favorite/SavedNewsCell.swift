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
	
	let newsImageView = UIImageView(cornerRadius: CellSize.imageCornerRadius)
	let titleLabel = UILabel(text: "News Title", font: UIFont.preferredFont(forTextStyle: .body), numberOfLines: CellSize.titleNumberOfLines, color: .label)
	let sourceLabel = UILabel(text: "Author Label", font: UIFont.preferredFont(forTextStyle: .caption1), numberOfLines: CellSize.sourceNumberOfLines, color: .secondaryLabel)
	
	let separator = SeparatorView()

	var articleResult: SavedArticle!   {
        didSet  {
            titleLabel.text = articleResult.title
			newsImageView.sd_setImage(with: URL(string: articleResult.urlToImage), placeholderImage: ConfigEnv.placeHolder)
            sourceLabel.text = "\(articleResult.publisherName) • \(articleResult.publishedAt.prefix(10))"
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
		backgroundColor = .systemBackground
		newsImageView.image = #imageLiteral(resourceName: "News_iOS_Icon")
        newsImageView.clipsToBounds = true
		newsImageView.constrainWidth(constant: CellSize.imageWidth )
		newsImageView.constrainHeight(constant: CellSize.imageHeight)
		newsImageView.layer.borderWidth = CellSize.cellBorderWidth
		newsImageView.layer.borderColor = UIColor.systemGray.cgColor
		
		sourceLabel.textAlignment = .right
        
        let stackView = UIStackView(arrangedSubviews: [
            newsImageView,
            VerticalStackView(arrangedSubviews: [titleLabel, sourceLabel], spacing: 4)])
		stackView.spacing = CellSize.spacingImage2Content
		stackView.alignment = .center
		
		addSubviews(stackView, separator)
		stackView.fillSuperview(padding: .init(top: 0, left: CellSize.minimumSpacingSection/2, bottom: 0, right: CellSize.minimumSpacingSection/2))

		separator.anchor(top: nil, leading: sourceLabel.leadingAnchor, bottom: newsImageView.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: CellSize.separatorPaddingfromBootm, right: 0), size: .init(width: 0, height: CellSize.separatorLineWidth))
	}
}
