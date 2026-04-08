//
//  Titles.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 08/04/26.
//

import Foundation

struct Title: Codable, Identifiable, Hashable {
    let id: Int          // 👈 from ids.trakt
    let title: String
    let images: Images?

    let ids: IDs

    // Map id from ids.trakt
    enum CodingKeys: String, CodingKey {
        case title
        case images
        case ids
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        images = try container.decodeIfPresent(Images.self, forKey: .images)
        ids = try container.decode(IDs.self, forKey: .ids)
        
        // 👇 assign id from trakt
        id = ids.trakt ?? 0
    }
    init(title: String, images: Images?, ids: IDs) {
          self.title = title
          self.images = images
          self.ids = ids
          self.id = ids.trakt ?? 0
      }
  
}

struct TrendingItem: Decodable {
    let watchers: Int
    let title: Title

    enum CodingKeys: String, CodingKey {
        case watchers
        case show
        case movie
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        watchers = try container.decode(Int.self, forKey: .watchers)

        if let show = try container.decodeIfPresent(Title.self, forKey: .show) {
            title = show
        } else if let movie = try container.decodeIfPresent(Title.self, forKey: .movie) {
            title = movie
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .show,
                in: container,
                debugDescription: "No show or movie found"
            )
        }
    }
}

struct AnticipatedItem: Decodable {
    let listCount: Int
    let title: Title

    enum CodingKeys: String, CodingKey {
        case listCount
        case movie
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        listCount = try container.decode(Int.self, forKey: .listCount)
        title = try container.decode(Title.self, forKey: .movie)
    }
}

struct SearchItem: Decodable {
    let score: Double
    let title: Title

    enum CodingKeys: String, CodingKey {
        case score
        case movie
        case show
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        score = try container.decode(Double.self, forKey: .score)

        if let movie = try container.decodeIfPresent(Title.self, forKey: .movie) {
            title = movie
        } else if let show = try container.decodeIfPresent(Title.self, forKey: .show) {
            title = show
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .movie,
                in: container,
                debugDescription: "No movie or show found"
            )
        }
    }
}

// MARK: - IDs
struct IDs: Codable, Hashable {
    let trakt: Int?
}

// MARK: - Images
struct Images: Codable, Hashable{
    let poster: [String]?
}

extension Title {
    var posterURL: URL? {
        guard let path = images?.poster?.first else { return nil }
        return URL(string: "https://\(path)")
    }
    

}
