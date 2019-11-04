//
//  Service.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-25.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import Foundation
import RealmSwift

class Service   {
    static let shared = Service()
    
    func fetchUSBusinessNews(completion: @escaping (newsGroup?, Error?)->())   {
        let urlString: String = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=3db7a9ee619e49f0b297bccda7da5eb5"
        
        guard let url: URL = URL(string: urlString) else { return }
        fetchGenericsJSONData(url: url, completion: completion)
    }
    
    func fetchJapanBusinessNews(completion: @escaping (newsGroup?, Error?)->())   {
        let urlString: String = "https://newsapi.org/v2/top-headlines?country=jp&category=business&apiKey=3db7a9ee619e49f0b297bccda7da5eb5"
        
        guard let url: URL = URL(string: urlString) else { return }
        fetchGenericsJSONData(url: url, completion: completion)
    }
    
    func fetchCategoryNews(type: String, completion: @escaping (newsGroup?, Error?)->())   {
        let urlString: String = "https://newsapi.org/v2/top-headlines?country=us&pageSize=24&category=\(type)&apiKey=3db7a9ee619e49f0b297bccda7da5eb5"
        
        guard let url: URL = URL(string: urlString) else { return }
        fetchGenericsJSONData(url: url, completion: completion)
    }
    
    func fetchNewsSearch(page: Int, limit: Int, search: String, completion: @escaping (newsGroup?, Error?)->Void)  {
        let urlString: String = "https://newsapi.org/v2/everything?q=\(search)&page=page=\(String(page))&pageSize=\(String(limit))&sortBy=publishedAt&apiKey=3db7a9ee619e49f0b297bccda7da5eb5"
        guard let url: URL = URL(string: urlString) else { return }
        fetchGenericsJSONData(url: url, completion: completion)
    }
    
        
    // A generic function to fetch different formats of JSON data.
    func fetchGenericsJSONData<tGeneric: Decodable>(url: URL, completion: @escaping (tGeneric?, Error?)->(Void))    {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Some mistakes in fetching API -> \(error)")
                completion(nil, error)
                return
            }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let news = try decoder.decode(tGeneric.self, from: data)
                completion(news, nil)
            }   catch let jsonErr   {
                completion(nil, jsonErr)
            }
            }.resume()
    }
}
