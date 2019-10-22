//
//  ImageStackView.swift
//  NewsClient
//
//  Created by chihhao on 2019-05-25.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class ImageStackView: UIStackView   {
    init(image: UIImage, customStackingNum: Int, width: CGFloat, height: CGFloat)   {
        super.init(frame: .zero)
        var arrangedSubViews = [UIView]()
        (0..<customStackingNum).forEach { (_) in
            let imageView = UIImageView(image: image)
            imageView.constrainHeight(constant: height)
            imageView.constrainWidth(constant: width)
            arrangedSubViews.append(imageView)
        }
        arrangedSubViews.append(UIView())
        arrangedSubViews.forEach({ addArrangedSubview($0)})
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

