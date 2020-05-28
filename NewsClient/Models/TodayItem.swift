//
//  TodayItem.swift
//  NewsClient
//
//  Created by chihhao on 2019-05-30.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

struct TodayItem {
    let category: String
    let title: String
    let backgroundColor: UIColor

    // enum type
    let cellType: CellType
    
    enum CellType: String {
        case single, multiple
    }
    
    var newsFetch: [Article]
}


