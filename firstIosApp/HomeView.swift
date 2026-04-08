//
//  HomeView.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 04/04/26.
//

import SwiftUI

struct HomeView: View {
    var heroTestTitle = AppConstants.testTitleURL
    let viewModel = ViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                LazyVStack{
                    AsyncImage(url: URL(string: heroTestTitle)){
                        image in image.resizable().scaledToFit().overlay{
                            LinearGradient(
                                stops: [Gradient.Stop(color: .clear, location: 0.8),
                                        Gradient.Stop(color: .gradient, location: 1)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                    } placeholder: {
                        ProgressView()
                    }.frame(width: geo.size.width,height: geo.size.height*0.85)
                    
                    HStack{
                        Button{
                            
                        } label: {
                            Text(AppConstants.playString).ghostButton()
                        }
                        
                        Button{
                            
                        } label: {
                            Text(AppConstants.downloadString).ghostButton()
                        }
                        
                    }
                    
                    horizontalListView(header: AppConstants.trendingMovieString,titles:viewModel.trendingMovies)
                    horizontalListView(header: AppConstants.topRatedMovieString,titles:viewModel.popularMovies)
                    horizontalListView(header: AppConstants.trendingTVString,titles:viewModel.trendingTV)
                    horizontalListView(header: AppConstants.topRatedTVString,titles:viewModel.popularTV)
                 
                    
                    

                }
            }.task {
                await viewModel.getTitles()
            }
        }
    }
}

#Preview {
    HomeView()
}
