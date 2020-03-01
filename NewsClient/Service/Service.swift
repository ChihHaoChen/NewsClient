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
    
    func fetchUSTopNews(completion: @escaping (newsGroup?, Error?)->())   {
        let urlString: String = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)"
        
        guard let url: URL = URL(string: urlString) else { return }
        fetchGenericsJSONData(url: url, completion: completion)
    }
    
    func fetchJapanTopNews(completion: @escaping (newsGroup?, Error?)->())   {
        let urlString: String = "https://newsapi.org/v2/top-headlines?country=jp&apiKey=\(apiKey)"
        
        guard let url: URL = URL(string: urlString) else { return }
        fetchGenericsJSONData(url: url, completion: completion)
    }
    
	func fetchCanadaTopNews(completion: @escaping (newsGroup?, Error?)->())   {
        let urlString: String = "https://newsapi.org/v2/top-headlines?country=ca&apiKey=\(apiKey)"
        
        guard let url: URL = URL(string: urlString) else { return }
        fetchGenericsJSONData(url: url, completion: completion)
    }
	
	func fetchTaiwanTopNews(completion: @escaping (newsGroup?, Error?)->())   {
        let urlString: String = "https://newsapi.org/v2/top-headlines?country=tw&apiKey=\(apiKey)"
        
        guard let url: URL = URL(string: urlString) else { return }
        fetchGenericsJSONData(url: url, completion: completion)
    }
	
    func fetchCategoryNews(type: String, completion: @escaping (newsGroup?, Error?)->())   {
        let urlString: String = "https://newsapi.org/v2/top-headlines?country=us&pageSize=24&category=\(type)&apiKey=\(apiKey)"
        
        guard let url: URL = URL(string: urlString) else { return }
        fetchGenericsJSONData(url: url, completion: completion)
    }
    
    func fetchNewsSearch(page: Int, limit: Int, search: String, completion: @escaping (newsGroup?, Error?)->Void)  {
		
		var components = URLComponents(string: "https://newsapi.org/v2/everything")!
		components.queryItems = [
			URLQueryItem(name: "q", value: search),
			URLQueryItem(name: "page=page", value: String(page)),
			URLQueryItem(name: "pageSize", value: String(limit)),
			URLQueryItem(name: "sortBy", value: "publishedAt"),
			URLQueryItem(name: "apiKey", value: apiKey)
		]
		
		components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

		guard let url: URL = components.url else { return }
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
