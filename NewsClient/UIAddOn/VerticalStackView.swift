//
//  VerticalStackView.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-22.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class VerticalStackView: UIStackView    {
    init(arrangedSubviews: [UIView], spacing: CGFloat = 0)    {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = spacing
        
        arrangedSubviews.forEach({ addArrangedSubview($0) })
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

