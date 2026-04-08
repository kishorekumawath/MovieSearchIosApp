//
//  VerticalListView.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 08/04/26.
//

import SwiftUI

struct VerticalListView: View {
    var titles: [Title]
    let canDelete: Bool
    
    var body: some View {
        List(titles) { title in
            NavigationLink {
                TitleDetailView(title: title)
            } label: {
                AsyncImage(url: title.posterURL) { image in
                    HStack {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 10))
                            .padding(5)
                        
                        Text((title.title))
                            .font(.system(size: 14))
                            .bold()
                    }
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 150)
            }
            .swipeActions(edge: .trailing) {
                if canDelete {
                    Button {
//                        modelContext.delete(title)
//                        try? modelContext.save()
                    } label: {
                        Image(systemName: "trash")
                            .tint(.red)
                    }
                }
            }
            
            
        }
    }
}

#Preview {
    VerticalListView(titles:  [
        Title(
            title: "Demo",
            images: Images(
                poster: ["media.trakt.tv/images/shows/000/206/790/posters/medium/e255ecc15c.jpg.webp"]
            ),
            ids: IDs(trakt: 1)
        )
    ], canDelete: true)
}
