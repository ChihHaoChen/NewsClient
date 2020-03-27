//
//  UIAlertViewController.swift
//  NewsClient
//
//  Created by ChihHao on 2020/02/27.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit

class UIAlertViewController: UIViewController {
	
	var alertTitle: String?
	var message: String?
	var buttonTitle: String?
	
	var padding: CGFloat = 20
	let containerWidth: CGFloat = ScreenSize.width*0.67
	
	let containerView = AlertContainerView()
	let blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
	
	let titleLabel = UILabel(text: "No Saved Articles", font: UIFont.preferredFont(forTextStyle: .title2).bold(), color: .systemOrange)
	let messageLabel = UILabel(text: "Save the articles of your interest by pinning them.", font: UIFont.preferredFont(forTextStyle: .body), color: .label)
	let actionButton = UIButton(title: "Gotcha", titleColor: .label, font: UIFont.preferredFont(forTextStyle: .headline).bold(), width: ScreenSize.width-2*20, height: 44, cornerRadius: CellSize.imageCornerRadius)
	
	init(alertTitle: String, message: String, buttonTitle: String)   {
		super.init(nibName: nil, bundle: nil)
		self.alertTitle = alertTitle
		self.message = message
		self.buttonTitle = buttonTitle
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		
		
		configureUIElements()
	}
	
	
	// MARK: - Configure the UI elements in AlertView Container
	func configureUIElements()	{
		view.addSubviews(blurVisualEffect, containerView, titleLabel, actionButton, messageLabel)
		
		blurVisualEffect.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		actionButton.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		
		blurVisualEffect.fillSuperview()
		
		configureContainerView()
		configureTitleLabel()
		configureActionButton()
		configureMessageLabel()
	}
	
	
	func configureContainerView()   {
		containerView.centerInSuperview(size: .init(width: containerWidth, height: 200))
	}
	
	
	func configureTitleLabel()  {
		titleLabel.text = alertTitle ?? "Some other title"
		titleLabel.textAlignment = .center
		
		titleLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: padding, left: padding, bottom: 0, right: padding), size: .init(width: containerWidth-2*padding, height: 28))
	}
	
	
	func configureActionButton()  {
		actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
		
		actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
		
		
		actionButton.anchor(top: nil, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: padding, bottom: padding, right: padding))
		actionButton.backgroundColor = .systemOrange
	}
	
	
	@objc func dismissVC()	{
		dismiss(animated: true, completion: nil)
	}
	
	
	func configureMessageLabel()	{
		messageLabel.text = message ?? "Unable to complete the request"
		messageLabel.numberOfLines = 2
		messageLabel.textAlignment = .center
		
		messageLabel.anchor(top: titleLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: actionButton.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 8, left: padding, bottom: 8, right: padding))
	}
}


