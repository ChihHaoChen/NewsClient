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
    let titleLabel = UILabel(text: "News Name", font: .systemFont(ofSize: 16*(UIScreen.main.bounds.width/320)), numberOfLines: 2)
    let nameLabel = UILabel(text: "Publisher Name", font: .systemFont(ofSize: 13))
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        newsRowIcon.constrainWidth(constant: UIScreen.main.bounds.width/3.3)
        newsRowIcon.constrainHeight(constant: UIScreen.main.bounds.width/4.5)
        let stackView = UIStackView(arrangedSubviews: [newsRowIcon, VerticalStackView(arrangedSubviews: [titleLabel, nameLabel], spacing: 4)])
        stackView.spacing = 16
        stackView.alignment = .center
        addSubview(stackView)
        stackView.fillSuperview()
        
        addSubview(separator)
        separator.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 0.5))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
