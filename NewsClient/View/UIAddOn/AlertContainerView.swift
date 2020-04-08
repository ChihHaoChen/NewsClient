//
//  AlertContainerView.swift
//  NewsClient
//
//  Created by ChihHao on 2020/02/27.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit

class AlertContainerView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func configure()   {
		backgroundColor = .systemBackground
		layer.cornerRadius = CellSize.imageCornerRadius
		layer.borderWidth = 2
		layer.borderColor = UIColor.gray.cgColor
		translatesAutoresizingMaskIntoConstraints = false
	}
}
