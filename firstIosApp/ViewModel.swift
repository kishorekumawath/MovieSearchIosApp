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
    private(set) var videoIdStatus: FetchStatus = .notStarted
    private let dataFetcher = DataFetcher()
    var trendingMovies: [Title] = []
       var trendingTV: [Title] = []
       var popularMovies: [Title] = []
       var popularTV: [Title] = []
       var heroTitle = Title(
        title: "Demo",
        images: Images(
            poster: ["media.trakt.tv/images/shows/000/206/790/posters/medium/e255ecc15c.jpg.webp"]
        ),
        ids: IDs(trakt: 1)
    )
    var videoId = ""
    
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
            if let title = trendingMovies.randomElement() {
                                heroTitle = title
                            }
            homeStatus = .success
            
        } catch {
            print(error)
            homeStatus = .failed(underlyingError: error)
        }
    }
    func getVideoId(for title: String) async {
            videoIdStatus = .fetching
            
            do {
                videoId = try await dataFetcher.fetchVideoId(for: title)
                videoIdStatus = .success
            } catch {
                print(error)
                videoIdStatus = .failed(underlyingError: error)
            }
        }
}
