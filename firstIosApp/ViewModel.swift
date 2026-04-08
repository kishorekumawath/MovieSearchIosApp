//
//  ViewModel.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 08/04/26.
//

import Foundation

@Observable
class ViewModel{
    enum FetchStatus {
           case notStarted
           case fetching
           case success
           case failed(underlyingError: Error)
       }
    private(set) var homeStatus: FetchStatus = .notStarted
    private let dataFetcher = DataFetcher()
    var trendingMovies: [Title] = []
       var trendingTV: [Title] = []
       var popularMovies: [Title] = []
       var popularTV: [Title] = []
    
    func getTitles() async {
        homeStatus = .fetching
        
        do {
            async let tMovies = dataFetcher.fetchTitles(for: "movies", by: "trending")
            async let tTV = dataFetcher.fetchTitles(for: "shows", by: "trending")
            async let pMovies = dataFetcher.fetchTitles(for: "movies", by: "popular")
            async let pTV = dataFetcher.fetchTitles(for: "shows", by: "popular")
            
            trendingMovies = try await tMovies
            trendingTV = try await tTV
            popularMovies = try await pMovies
            popularTV = try await pTV
            
            homeStatus = .success
            
        } catch {
            print(error)
            homeStatus = .failed(underlyingError: error)
        }
    }
}
