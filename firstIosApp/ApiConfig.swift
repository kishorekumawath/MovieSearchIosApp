//
//  ApiConfig.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 05/04/26.
//

import Foundation
struct APIConfig: Decodable{
    let traktBaseURL: String
    let traktClientID: String
    let youtubeAPIKey: String
    let youtubeBaseURL: String
    let youtubeSearchURL: String
    
    static let shared: APIConfig? = {
        do{
            return try loadConfig()
        }catch{
            print("Failed to load API config: \(error.localizedDescription)")
                       return nil
        }
    }()
    
    private static func loadConfig() throws -> APIConfig {
           guard let url = Bundle.main.url(forResource: "APIConfig", withExtension: "json") else {
               throw APIConfigError.fileNotFound
           }
           
           do {
               let data = try Data(contentsOf: url)
               return try JSONDecoder().decode(APIConfig.self, from: data)
           } catch let error as DecodingError {
               throw APIConfigError.decodingFailed(underlyingError: error)
           } catch {
               throw APIConfigError.dataLoadingFailed(underlyingError: error)
           }
       }
    
}
