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


extension UIActivityIndicatorView {
	convenience init(color: UIColor, style: UIActivityIndicatorView.Style) {
		self.init(frame: .zero)
		self.color = color
		self.hidesWhenStopped = true
		self.style = style
		self.startAnimating()
	}
}


extension UIViewController	{
	func presentAlertOnMainThread(title: String, message: String, buttonTitle: String)	{
		DispatchQueue.main.async {
			let alertVC = UIAlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)
			alertVC.modalPresentationStyle = .overFullScreen
			alertVC.modalTransitionStyle = .crossDissolve
			
			self.present(alertVC, animated: true, completion: nil)
		}
	}
}

extension CAShapeLayer {
	func curveCorner(in view: UIView) {
		// 1st step: Mask round corner
		let layerCornerRadius: CGFloat = 44
		let pathWithRadius = UIBezierPath(roundedRect: view.bounds, cornerRadius: layerCornerRadius)
		let roundLayer = CAShapeLayer()
		roundLayer.path = pathWithRadius.cgPath
		roundLayer.frame = view.bounds
		view.layer.mask = roundLayer
		
		// 2nd step: Add border to round curve
		let roundPath = UIBezierPath()
		roundPath.move(to: CGPoint(x: 0, y: layerCornerRadius))
		roundPath.addQuadCurve(to: CGPoint(x: layerCornerRadius, y: 0), controlPoint: CGPoint(x: 0, y: 0))
		roundPath.addLine(to: CGPoint(x: view.frame.width-layerCornerRadius, y: 0))
		roundPath.addQuadCurve(to: CGPoint(x: view.frame.width, y: layerCornerRadius), controlPoint: CGPoint(x: view.frame.width, y: 0))
		
		let borderLayer = CAShapeLayer()
		borderLayer.lineWidth = 4
		borderLayer.borderColor = UIColor.systemGray4.cgColor
		borderLayer.path = roundPath.cgPath
		borderLayer.fillColor = UIColor.systemGray4.cgColor
		view.layer.addSublayer(borderLayer)
	}
}
