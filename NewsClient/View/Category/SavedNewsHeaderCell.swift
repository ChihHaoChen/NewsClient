//
//  SavedNewsHeaderCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-28.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class SavedNewsHeaderCell: UICollectionViewCell  {
    var article: Article! {
        didSet {
            newsTitle.text = article.title
            pusblishedAt.text = "\(article.source?.name ?? "") • \(article.publishedAt?.prefix(10) ?? "")"
            newsImageView.sd_setImage(with: URL(string: article.urlToImage ?? ""), placeholderImage: UIImage(named: "News_iOS_Icon"))
        }
    }
    let newsTitle = UILabel(text: "", font: .systemFont(ofSize: 20*(UIScreen.main.bounds.width/320)), numberOfLines: 2)
    let pusblishedAt = UILabel(text: "", font: .systemFont(ofSize: 10*(UIScreen.main.bounds.width/320)))
    let newsImageView = UIImageView(cornerRadius: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        newsImageView.constrainHeight(constant: self.frame.width/2)
        let vstack = VerticalStackView(arrangedSubviews: [newsImageView, newsTitle, pusblishedAt], spacing: 4)
        addSubview(vstack)
        vstack.fillSuperview(padding: .init(top: 12, left: 0, bottom: 0, right: 0))
        pusblishedAt.textColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
