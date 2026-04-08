//
//  TitleDetailView.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 08/04/26.
//

import SwiftUI

struct TitleDetailView: View {
    
    let title: Title
    var titleName: String {
        return (title.title)
    }
    let viewModel = ViewModel()
    
    var body: some View {
       GeometryReader { geometry in
           switch viewModel.videoIdStatus {
           case .notStarted:
               EmptyView()
           case .fetching:
               ProgressView()
                   .frame(width: geometry.size.width, height: geometry.size.height)
           case .success:
               ScrollView {
                   LazyVStack(alignment: .leading) {
                       YouTubePlayerView(videoId: viewModel.videoId)
                           .aspectRatio(1.3, contentMode: .fit)
                       
                       Text(titleName)
                           .bold()
                           .font(.title2)
                           .padding(5)
                       
                       HStack {
                           Spacer()
                           
                           Button {
//                               let saveTitle = title
//                               saveTitle.title = titleName
//                               modelContext.insert(saveTitle)
//                               try? modelContext.save()
//                               dismiss()
                           } label: {
                               Text(AppConstants.downloadString)
                                   .ghostButton()
                           }
                           
                           Spacer()
                       }
                      
                   }
               }
           case .failed(let underlyingError):
               Text(underlyingError.localizedDescription)
                   .errorMessage()
                   .frame(width: geometry.size.width, height: geometry.size.height)
           }
        }
       .task {
           await viewModel.getVideoId(for: titleName)
       }
    }
}


#Preview {
    TitleDetailView(title: Title(
        title: "Demo",
        images: Images(
            poster: ["media.trakt.tv/images/shows/000/206/790/posters/medium/e255ecc15c.jpg.webp"]
        ),
        ids: IDs(trakt: 1)
    ))
}
