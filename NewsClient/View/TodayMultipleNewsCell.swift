//
//  TodayMultipleNewsCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-06-03.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class TodayMultipleNewsCell: BaseTodayCell    {
    override var todayItem: TodayItem!    {
        didSet  {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            todayMultipleNewsController.articles = todayItem.newsFetch
            todayMultipleNewsController.articleCategory = todayItem.category
            todayMultipleNewsController.articleTitle = todayItem.title
            todayMultipleNewsController.collectionView.reloadData()
        }
    }
    
    let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Utilizing Your Time", font: .boldSystemFont(ofSize: 32), numberOfLines: 2)
    let todayMultipleNewsController = TodayMultipleNewsController(mode: .small)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 16
        
        let vstack = VerticalStackView(arrangedSubviews: [
            categoryLabel,
            titleLabel,
            todayMultipleNewsController.view
            ], spacing: 8)
        addSubview(vstack)
        vstack.fillSuperview(padding: .init(top: 20, left: 16, bottom: 20, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
