//
//  SeparatorView.swift
//  NewsClient
//
//  Created by ChihHao on 2020/03/20.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit

class SeparatorView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func configure() {
		backgroundColor = .separator
	}
	
	
	override var intrinsicContentSize: CGSize {
		return CGSize(width: ScreenSize.width-2*CellSize.minimumSpacingSection, height: CellSize.separatorLineWidth)
	}
}
