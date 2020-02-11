//
//  SavedNewsHeaders.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-27.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class SavedNewsHeaders: UICollectionReusableView {
	
	let savedNewsLabel = UILabel(text: "The Saved Articles", font: UIFont.preferredFont(forTextStyle: .largeTitle).bold(), numberOfLines: 1, color: .label)
    let savedNewsHorizontalController = SavedNewsHeaderHorizontalController()
    let separatorBot: UIView = {
        let view = UIView()
		view.backgroundColor = .separator
        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
		addSubviews(savedNewsLabel, savedNewsHorizontalController.view, separatorBot)
        
		savedNewsLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: frame.width - 16, height: 60))
		
		savedNewsHorizontalController.view.anchor(top: savedNewsLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))

        separatorBot.anchor(top: savedNewsHorizontalController.view.bottomAnchor, leading: savedNewsHorizontalController.view.leadingAnchor, bottom: nil, trailing: savedNewsHorizontalController.view.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 1))
    }
    
	
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
