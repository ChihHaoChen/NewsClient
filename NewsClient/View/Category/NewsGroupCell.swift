//
//  NewsGroupCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-25.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class NewsGroupCell: UICollectionViewCell   {
   
    let titleLabel = UILabel(text: "News Selection", font: .boldSystemFont(ofSize: 24*(UIScreen.main.bounds.width/320)))
    let horizontalController = NewsHorizontalController()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 12, left: 16, bottom: 0, right: 0))
        addSubview(horizontalController.view)
        horizontalController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}