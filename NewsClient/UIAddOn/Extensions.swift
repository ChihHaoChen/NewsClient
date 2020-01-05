//
//  Extensions.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-25.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

extension UILabel   {
	convenience init(text: String, font: UIFont, numberOfLines: Int = 1, color: UIColor)    {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.numberOfLines = numberOfLines
		self.textColor = color
    }
}

extension UIImageView   {
    convenience init(cornerRadius: CGFloat) {
        self.init(frame: .zero)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds  = true
        self.contentMode = .scaleAspectFill
    }
}

extension UIButton  {
    convenience init(title: String, titleColor: UIColor, font: UIFont, width: CGFloat, height: CGFloat, cornerRadius: CGFloat) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.constrainWidth(constant: width)
        self.constrainHeight(constant: height)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}

extension UIStackView   {
    convenience init(arrangedSubviews: [UIView], customSpacing: CGFloat = 0)    {
        self.init(arrangedSubviews: arrangedSubviews)
        self.spacing = customSpacing
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
