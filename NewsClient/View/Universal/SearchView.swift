//
//  SearchView.swift
//  NewsClient
//
//  Created by ChihHao on 2020/03/21.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit

class SearchView: UIView {
	
	fileprivate let searchController = UISearchController(searchResultsController: nil)

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureSearchNewsBar()
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func configureSearchNewsBar() {
		addSubview(searchController.view)
	}
}
