//
//  AppGroup.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-28.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import Foundation

struct newsGroup: Decodable  {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable  {
    var source: Source?
    var title: String?
    var description: String?
    var url: String
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

struct Source: Decodable {
    let name: String?
    let author: String?
}

