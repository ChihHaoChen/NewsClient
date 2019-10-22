//
//  searchResults.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-24.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import Foundation

struct SearchResult: Decodable  {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    let averageUserRatingForCurrentVersion: Float?
    let artworkUrl100: String
    let screenshotUrls: [String]
    var formattedPrice: String?
    let description: String
    var releaseNotes: String?
}
