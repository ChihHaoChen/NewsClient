//
//  TodayMultipleNewsHeaderCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-10-16.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class TodayMultipleNewsHeaderCell: UICollectionViewCell {
//    let categoryLabel = UILabel(text: "Top News", font: .boldSystemFont(ofSize: 16*(UIScreen.main.bounds.width/320)))
//    let titleLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 25*(UIScreen.main.bounds.width/320)), numberOfLines: 1)
    let categoryLabel = UILabel(text: "Top News", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 26), numberOfLines: 1)
    override init(frame: CGRect) {
        super.init(frame: frame)
        let vstack = VerticalStackView(arrangedSubviews: [
            titleLabel,
            categoryLabel
            ], spacing: 8)
        addSubview(vstack)
        vstack.fillSuperview(padding: .init(top: 20, left: 16, bottom: 8, right: 16))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
