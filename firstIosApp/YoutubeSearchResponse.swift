//
//  YoutubeSearchResponse.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 08/04/26.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [ItemProperties]?
}

struct ItemProperties: Codable {
    let id: IdProperties?
}

struct IdProperties: Codable {
    let videoId: String?
}
  
