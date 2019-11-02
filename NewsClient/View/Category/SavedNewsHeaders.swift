//
//  SavedNewsHeaders.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-27.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class SavedNewsHeaders: UICollectionReusableView {
    let savedNewsHorizontalController = SavedNewsHeaderHorizontalController()
    let separatorBot: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }()
    let separatorTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(savedNewsHorizontalController.view)
        savedNewsHorizontalController.view.fillSuperview(padding: .init(top: 8, left: 0, bottom: 0, right: 0))

        addSubview(separatorBot)
        separatorBot.anchor(top: savedNewsHorizontalController.view.bottomAnchor, leading: savedNewsHorizontalController.view.leadingAnchor, bottom: nil, trailing: savedNewsHorizontalController.view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
