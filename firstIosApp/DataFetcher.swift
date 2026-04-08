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
    let youtubeAPIKey = APIConfig.shared?.youtubeAPIKey
    let youtubeSearchURL = APIConfig.shared?.youtubeSearchURL
    
    
    func fetchTitles(for media: String, by type: String, with title: String? = nil) async throws -> [Title] {
        
        let fetchTitlesURL = try buildURL(media: media, type: type, searchPhrase: title)
        
        guard let fetchTitlesURL else {
            throw NetworkError.urlBuildFailed
        }
        
    
        if type == "trending" {
            let response: [TrendingItem] = try await fetchAndDecodeTRAKT(
                url: fetchTitlesURL,
                type: [TrendingItem].self
            )
            
    
            return response.map { $0.title }
            
        } else if type == "anticipated" {
            
            let response: [AnticipatedItem] = try await fetchAndDecodeTRAKT(
                url: fetchTitlesURL,
                type: [AnticipatedItem].self
            )

            return response.map { $0.title }

        } else {

            return try await fetchAndDecodeTRAKT(
                url: fetchTitlesURL,
                type: [Title].self
            )
        }
    }
    
    //https://www.googleapis.com/youtube/v3/search?q=Breaking%20Bad%20trailer&key=APIKEY
      func fetchVideoId(for title: String) async throws -> String {
          guard let baseSearchURL = youtubeSearchURL else {
              throw NetworkError.missingConfig
          }
          
          guard let searchAPIKey = youtubeAPIKey else {
              throw NetworkError.missingConfig
          }
          
          let trailerSearch = title + YoutubeURLStrings.space.rawValue + YoutubeURLStrings.trailer.rawValue
          
          guard let fetchVideoURL = URL(string: baseSearchURL)?.appending(queryItems: [
              URLQueryItem(name: YoutubeURLStrings.queryShorten.rawValue, value: trailerSearch),
              URLQueryItem(name: YoutubeURLStrings.key.rawValue, value: searchAPIKey)
          ]) else {
              throw NetworkError.urlBuildFailed
          }
          
          print(fetchVideoURL)
          
          return try await fetchAndDecode(url: fetchVideoURL, type: YoutubeSearchResponse.self).items?.first?.id?.videoId ?? ""
      }
    
    func fetchAndDecodeTRAKT<T: Decodable>(
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
    
    func fetchAndDecode<T: Decodable>(url: URL, type: T.Type) async throws -> T {
          let(data,urlResponse) = try await URLSession.shared.data(from: url)
          
          guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
              throw NetworkError.badURLResponse(underlyingError: NSError(
                  domain: "DataFetcher",
                  code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1,
                  userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"]))
          }
          
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          return try decoder.decode(type, from: data)
      }
    
    private func buildURL(media:String,type:String,searchPhrase:String? = nil) throws -> URL? {
           guard let baseURL = traktBaseURL else {
               throw NetworkError.missingConfig
           }

           var path:String
           
           if type == "trending" {
               path = "\(media)/\(type)"
           } else if type == "popular" || type == "anticipated" {
               path = "\(media)/\(type)"
           }
        else {
               throw NetworkError.urlBuildFailed
           }
           
           
           guard let url = URL(string: baseURL)?
               .appending(path: path)

        else {
               throw NetworkError.urlBuildFailed
           }
           
           return url
       }
    
}
