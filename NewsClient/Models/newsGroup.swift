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
    let source: Source?
    let title: String?
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Decodable {
    let name: String?
    let author: String?
}


