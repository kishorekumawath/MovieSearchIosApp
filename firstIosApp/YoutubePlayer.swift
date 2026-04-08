//
//  YoutubePlayer.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 08/04/26.

import SwiftUI
import YouTubeiOSPlayerHelper

struct YouTubePlayerView: UIViewRepresentable {
    let videoId: String
    
    func makeUIView(context: Context) -> YTPlayerView {
        let player = YTPlayerView()
        player.load(withVideoId: videoId)
        return player
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context) {}
}
