//
//  categoryGroup.swift
//  NewsClient
//
//  Created by chihhao on 2019-11-01.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import Foundation

struct categoryGroup: Decodable {
    var category: String
    var newsGroup: newsGroup
}
