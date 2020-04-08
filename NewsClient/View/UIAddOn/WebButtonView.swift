//
//  webButtonView.swift
//  NewsClient
//
//  Created by ChihHao on 2020/04/06.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit

class WebButtonView: UIView {
	
	let button = UIButton(title: "", titleColor: .red, font: .boldSystemFont(ofSize: 12), width: 64, height: 64, cornerRadius: 0)
	let blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	convenience init(viewBackgroundColor: UIColor, buttonImage: String) {
		self.init(frame: .zero)
	
		button.setImage(UIImage(named: buttonImage), for: .normal)
		button.alpha = 0.9

		backgroundColor = viewBackgroundColor
		
	}
	
	
	func configure() {
		
		translatesAutoresizingMaskIntoConstraints = false
		
		clipsToBounds = true
		layer.cornerRadius = 32
		
		self.centerXInSuperview()
		
		addSubviews(blurVisualEffect, button)
		blurVisualEffect.fillSuperview()
		button.fillSuperview()
	
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
	}
	
	
	@objc fileprivate func handleTap()   {
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.transform = .identity
		}, completion: nil)
	}
}
