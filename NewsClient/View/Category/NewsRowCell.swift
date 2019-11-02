//
//  NewsRowCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-25.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class NewsRowCell: UICollectionViewCell    {
    let newsRowIcon = UIImageView(cornerRadius: 12)
    let titleLabel = UILabel(text: "News Title", font: .systemFont(ofSize: 16*(UIScreen.main.bounds.width/320)), numberOfLines: 2)
    let publisherLabel = UILabel(text: "Publisher", font: .systemFont(ofSize: 13*(UIScreen.main.bounds.width/320)))
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        newsRowIcon.backgroundColor = .white
        // By the UIView+Layout helper
        newsRowIcon.constrainWidth(constant: self.frame.width/3.3)
        newsRowIcon.constrainHeight(constant: self.frame.width/4.5)
        
        let stackView = UIStackView(arrangedSubviews: [newsRowIcon, VerticalStackView(arrangedSubviews: [titleLabel, publisherLabel], spacing: 4)])
        stackView.spacing = 8
        stackView.alignment = .center
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        addSubview(separator)
        separator.anchor(top: nil, leading: titleLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 0.5))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
