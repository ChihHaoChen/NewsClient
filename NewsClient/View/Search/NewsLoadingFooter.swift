//
//  NewsLoadingFooter.swift
//  NewsClient
//
//  Created by chihhao on 2019-06-15.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class NewsLoadingFooter: UICollectionReusableView  {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        
        let loadingLabel = UILabel(text: "Loading...", font: .systemFont(ofSize: 16))
        
        let verticalStack = VerticalStackView(arrangedSubviews: [aiv, loadingLabel], spacing: 8)
        addSubview(verticalStack)
        verticalStack.centerInSuperview(size: .init(width: 200, height: 0))
        verticalStack.alignment = .center
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
