//
//  horizontalListView.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 05/04/26.
//

import SwiftUI

struct horizontalListView: View {
    let header :String
    var titles :[Title]
    var body: some View {
        VStack(alignment: .leading,){
            Text(header).font(.title)
            ScrollView(.horizontal){
                LazyHStack{
                    ForEach(titles){
                        title in AsyncImage(url: title.posterURL){
                            image in image.resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 12))
                        } placeholder: {
                            ProgressView()
                        }.frame(width: 120, height: 200)
                    }
                }
            }
        }.frame(height: 250).padding()
    }
}

#Preview {
    horizontalListView(
        header: "Trending",
        titles: [
            Title(
                title: "Demo",
                images: Images(
                    poster: ["media.trakt.tv/images/shows/000/206/790/posters/medium/e255ecc15c.jpg.webp"]
                ),
                ids: IDs(trakt: 1)
            )
        ]
    )
}
