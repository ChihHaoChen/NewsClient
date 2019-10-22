//
//  AppFullScreenHeaderCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-05-28.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class NewsFullScreenHeaderCell: UITableViewCell  {
    let todayCell = TodayViewCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        todayCell.layer.cornerRadius = 0
        addSubview(todayCell)
        todayCell.fillSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
