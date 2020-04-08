//
//  EmptySavedNewsView.swift
//  NewsClient
//
//  Created by ChihHao on 2020/04/08.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit

class EmptySavedNewsView: UIView {
	
	let messageLabel = UILabel(text: "", font: .preferredFont(forTextStyle: .title3), color: .secondaryLabel)
	let pinContainerView = WebButtonView(viewBackgroundColor: .green, buttonImage: "push-pin-90")

	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	convenience init(message: String) {
		self.init(frame: .zero)
		messageLabel.text = message
	}
	
	
	private func configure() {
		addSubviews(messageLabel, pinContainerView)
		configureMessageLabel()
		configureFloatingView()
	}
	
	
	private func configureMessageLabel() {
		messageLabel.centerInSuperview()
		messageLabel.textAlignment = .center
		messageLabel.numberOfLines = 2
	}
	
	
	private func configureFloatingView() {
		pinContainerView.anchor(top: messageLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: ConfigEnv.buttonVerticalPadding, left: 0, bottom: 0, right: 0))
		pinContainerView.centerXInSuperview()
	}
	
}
