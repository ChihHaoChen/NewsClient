//
//  NewsSearchCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-06-15.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class NewsSearchCell:  UICollectionViewCell  {
	
    var articleResult: Article!   {
        didSet  {
            titleLabel.text = articleResult.title
			imageView.sd_setImage(with: URL(string: articleResult.urlToImage ?? ""), placeholderImage: ConfigEnv.placeHolder)
            nameLabel.text = "\(articleResult.source?.name ?? "") • \(articleResult.publishedAt?.prefix(10) ?? "")"
        }
    }
   
	let imageView = UIImageView(cornerRadius: CellSize.imageCornerRadius)
	let titleLabel = UILabel(text: "News Title", font: UIFont.preferredFont(forTextStyle: .body), numberOfLines: CellSize.titleNumberOfLines, color: .label)
	let nameLabel = UILabel(text: "Author Label", font: UIFont.preferredFont(forTextStyle: .caption1), numberOfLines: 1, color: .secondaryLabel)
    
	let separator = SeparatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
		backgroundColor = .systemBackground
		
        imageView.image = #imageLiteral(resourceName: "News_iOS_Icon")
        imageView.clipsToBounds = true
		imageView.constrainWidth(constant: CellSize.imageWidth )
		imageView.constrainHeight(constant: CellSize.imageHeight)
		
		nameLabel.textAlignment = .right
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [titleLabel, nameLabel], spacing: 4)])
		
		stackView.spacing = CellSize.spacingImage2Content
        stackView.alignment = .center
		
		addSubviews(stackView, separator)
		stackView.fillSuperview()
        
		separator.anchor(top: nil, leading: titleLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: CellSize.separatorPaddingfromBootm, right: 0), size: .init(width: 0, height: CellSize.separatorLineWidth))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
