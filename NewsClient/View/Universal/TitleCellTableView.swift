//
//  TitleCellTableView.swift
//  NewsClient
//
//  Created by ChihHao on 2020/03/21.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit

class TitleCellTableView: UITableViewHeaderFooterView {
	
	static let reuseIdentifier: String = String(describing: self)
	let titleLabel = UILabel(text: "Title", font: UIFont.preferredFont(forTextStyle: .largeTitle).bold(), numberOfLines: 1, color: .label)
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .systemBackground
		
		contentView.addSubview(titleLabel)
		
		titleLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 16, left: 8, bottom: 16, right: 0))
		titleLabel.textAlignment = .center
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
