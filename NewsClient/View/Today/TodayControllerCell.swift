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
            countryLabel.text = todayItem.category
            newsLabel.text = todayItem.title
            todayMultipleNewsController.articles = todayItem.newsFetch
            todayMultipleNewsController.articleCategory = todayItem.category
            todayMultipleNewsController.articleTitle = todayItem.title
            todayMultipleNewsController.collectionView.reloadData()
        }
    }
    let newsLabel = UILabel(text: "NewsLabel", font: UIFont.preferredFont(forTextStyle: .largeTitle), numberOfLines: 1, color: .label)
	let countryLabel = UILabel(text: "Country", font: UIFont.preferredFont(forTextStyle: .title1), color: .secondaryLabel)
    let todayMultipleNewsController = TodayMultipleNewsController(mode: .small)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 12
        let vstack = VerticalStackView(arrangedSubviews: [
            newsLabel,
            countryLabel,
            todayMultipleNewsController.view
            ], spacing: 4)
        addSubview(vstack)
        vstack.fillSuperview(padding: .init(top: 12, left: 12, bottom: 12, right: 12))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
