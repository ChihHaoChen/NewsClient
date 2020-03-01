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
            nameLabel.text = articleResult.title
            imageView.sd_setImage(with: URL(string: articleResult.urlToImage ?? ""), placeholderImage: UIImage(named: "News_iOS_Icon"))
            descriptionLabel.text = "\(articleResult.source?.name ?? "") • \(articleResult.publishedAt?.prefix(10) ?? "")"
        }
    }
   
    let imageView = UIImageView(cornerRadius: 12)
	let nameLabel = UILabel(text: "News Title", font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 3, color: .label)
	let descriptionLabel = UILabel(text: "Author Label", font: UIFont.preferredFont(forTextStyle: .body), numberOfLines: 1, color: .label)
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = #imageLiteral(resourceName: "News_iOS_Icon")
        imageView.clipsToBounds = true
        imageView.constrainWidth(constant: self.frame.width/2.5 )
        imageView.constrainHeight(constant: self.frame.width/4)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [nameLabel, descriptionLabel], spacing: 4)
            ], customSpacing: 4)
		stackView.spacing = 12.8*(ScreenSize.width/320)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center
        addSubview(separator)
        separator.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
