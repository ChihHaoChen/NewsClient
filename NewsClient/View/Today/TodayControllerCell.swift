//
//  TodayMultipleNewsCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-06-03.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class TodayControllerCell: BaseTodayCell    {
    override var todayItem: TodayItem!    {
        didSet  {
            categoryLabel.text = todayItem.category
            newsLabel.text = todayItem.title
            todayMultipleNewsController.articles = todayItem.newsFetch
            todayMultipleNewsController.articleCategory = todayItem.category
            todayMultipleNewsController.articleTitle = todayItem.title
            todayMultipleNewsController.collectionView.reloadData()
        }
    }
    
	let categoryLabel = UILabel(text: "LIFE HACK", font: UIFont.preferredFont(forTextStyle: .title1), color: .label)
	let newsLabel = UILabel(text: "NewsLabel", font: UIFont.preferredFont(forTextStyle: .largeTitle), numberOfLines: 1, color: .secondaryLabel)
    let todayMultipleNewsController = TodayMultipleNewsController(mode: .small)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        let vstack = VerticalStackView(arrangedSubviews: [
            newsLabel,
            categoryLabel,
            todayMultipleNewsController.view
            ], spacing: 8)
        addSubview(vstack)
        vstack.fillSuperview(padding: .init(top: 20, left: 16, bottom: 20, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
