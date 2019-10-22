//
//  TodayViewCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-05-27.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class TodayViewCell: BaseTodayCell {
    override var todayItem: TodayItem! {
        didSet  {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            desLabel.text = todayItem.description
            imageView.image = todayItem.image
            backgroundColor = todayItem.backgroundColor
            backgroundView?.backgroundColor = todayItem.backgroundColor
        }
    }
    let imageView = UIImageView(image: #imageLiteral(resourceName: "holiday"))
    let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Utilizing Your Time", font: .boldSystemFont(ofSize: 28))
    let desLabel = UILabel(text: "All the tools and Apps you need to intelligently organize your life te right way", font: .systemFont(ofSize: 16), numberOfLines: 3)
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 16

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let imageContainerView = UIView()
        imageContainerView.addSubview(imageView)
        imageView.centerInSuperview(size: .init(width: 240, height: 240))
        
        let vstack = VerticalStackView(arrangedSubviews: [
            categoryLabel,
            titleLabel,
            imageContainerView,
            desLabel
            ], spacing: 8)
        
        addSubview(vstack)
        vstack.fillSuperview(padding: .init(top: 40, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
