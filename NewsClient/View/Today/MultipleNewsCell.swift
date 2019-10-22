//
//  MultipleAppCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-06-03.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class MultipleNewsCell: UICollectionViewCell {
    var article: Article! {
        didSet  {
            nameLabel.text = article.source?.name
            companyLabel.text = article.title
            appRowIcon.sd_setImage(with: URL(string: article.urlToImage ?? ""))
        }
    }
    let screenWidth = UIScreen.main.bounds.width
    let appRowIcon = UIImageView(cornerRadius: 12)
//    let appRowButton = UIButton(title: "GET", titleColor: .blue, font: .boldSystemFont(ofSize: 16), width: UIScreen.main.bounds.width/5, height: 32, cornerRadius: 32/2)
    let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 16*(UIScreen.main.bounds.width/320)))
    let companyLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 13))
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        // By the UIView+Layout helper
        appRowIcon.constrainWidth(constant: self.frame.width/2.5 )
        appRowIcon.constrainHeight(constant: self.frame.width/4.5)
        let stackView = UIStackView(arrangedSubviews: [appRowIcon, VerticalStackView(arrangedSubviews: [nameLabel, companyLabel], spacing: 4)])
        stackView.spacing = 12.8*(screenWidth/320)
        stackView.alignment = .center
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 6, bottom: 0, right: 6))
        
        addSubview(separator)
        separator.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 0.5))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
