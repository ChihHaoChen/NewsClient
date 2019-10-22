//
//  BaseCollectionViewController.swift
//  NewsClinet
//
//  Created by chihhao on 2019-04-25.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class BaseCollectionViewController: UICollectionViewController  {
    // UICollectionViewController must be initialized with "UICollectionViewFlowLayout for collectionViewLayout"
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
