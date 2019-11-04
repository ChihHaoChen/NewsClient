//
//  SavedData.swift
//  NewsClient
//
//  Created by chihhao on 2019-11-03.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import Foundation
import RealmSwift

class SavedArticle: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var newsDescription: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var urlToImage: String = ""
    @objc dynamic var publishedAt: String = ""
    @objc dynamic var publisherName: String = ""
}
