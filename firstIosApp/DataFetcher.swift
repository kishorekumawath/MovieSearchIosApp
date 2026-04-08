//
//  DataFetcher.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 08/04/26.
//

import Foundation

struct DataFetcher {
    let traktBaseURL = APIConfig.shared?.traktBaseURL
    let traktCilentID = APIConfig.shared?.traktClientID
    
    
    func fetchTitles(for media: String, by type: String, with title: String? = nil) async throws -> [Title] {
        
        let fetchTitlesURL = try buildURL(media: media, type: type, searchPhrase: title)
        
        guard let fetchTitlesURL else {
            throw NetworkError.urlBuildFailed
        }
        
    
        if type == "trending" {
            let response: [TrendingItem] = try await fetchAndDecode(
                url: fetchTitlesURL,
                type: [TrendingItem].self
            )
            
    
            return response.map { $0.title }
            
        } else {

            return try await fetchAndDecode(
                url: fetchTitlesURL,
                type: [Title].self
            )
        }
    }
    
    func fetchAndDecode<T: Decodable>(
        url: URL,
        type: T.Type
    ) async throws -> T {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
    
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2", forHTTPHeaderField: "trakt-api-version")
        request.setValue(traktCilentID, forHTTPHeaderField: "trakt-api-key")
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        
        guard let response = urlResponse as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw NetworkError.badURLResponse(underlyingError: NSError(
                domain: "DataFetcher",
                code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"]
            ))
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(type, from: data)
    }
    
    private func buildURL(media:String,type:String,searchPhrase:String? = nil) throws -> URL? {
           guard let baseURL = traktBaseURL else {
               throw NetworkError.missingConfig
           }
//           guard let apiKey = traktCilentID else {
//               throw NetworkError.missingConfig
//           }
           
           var path:String
           
           if type == "trending" {
               path = "\(media)/\(type)"
           } else if type == "popular" || type == "upcoming" {
               path = "\(media)/\(type)"
           }
//        else if type == "search" {
//               path = "3/\(type)/\(media)"
//           }
        else {
               throw NetworkError.urlBuildFailed
           }
           
//           var urlQueryItems = [
//               URLQueryItem(name: "api_key", value: apiKey)
//           ]
           
//           if let searchPhrase {
//               urlQueryItems.append(URLQueryItem(name: "query", value: searchPhrase))
//           }
           
           guard let url = URL(string: baseURL)?
               .appending(path: path)
//               .appending(queryItems: urlQueryItems)
        else {
               throw NetworkError.urlBuildFailed
           }
           
           return url
       }
    
}
