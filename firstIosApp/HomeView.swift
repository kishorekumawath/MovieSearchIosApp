//
//  HomeView.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 04/04/26.
//

import SwiftUI

struct HomeView: View {
 
    let viewModel = ViewModel()
    @State private var titleDetailPath = NavigationPath()
    var body: some View {
        NavigationStack (path: $titleDetailPath) {
            GeometryReader { geo in
                ScrollView {
                    
                        switch viewModel.homeStatus {
                        case .notStarted:
                            EmptyView()
                        case .fetching:
                            ProgressView()
                                .frame(width: geo.size.width, height: geo.size.height)
                        case .success:
                            LazyVStack {
                                AsyncImage(url: viewModel.heroTitle.posterURL){
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
                                        titleDetailPath.append(viewModel.heroTitle)
                                    } label: {
                                        Text(AppConstants.playString).ghostButton()
                                    }
                                    
                                    Button{
                                        
                                    } label: {
                                        Text(AppConstants.downloadString).ghostButton()
                                    }
                                    
                                }
                                
                                horizontalListView(header: AppConstants.trendingMovieString,titles:viewModel.trendingMovies){
                                    title in
                                    titleDetailPath.append(title)
                                }
                                horizontalListView(header: AppConstants.topRatedMovieString,titles:viewModel.popularMovies){
                                    title in
                                    titleDetailPath.append(title)
                                }
                                horizontalListView(header: AppConstants.trendingTVString,titles:viewModel.trendingTV){
                                    title in
                                    titleDetailPath.append(title)
                                }
                                horizontalListView(header: AppConstants.topRatedTVString,titles:viewModel.popularTV){
                                    title in
                                    titleDetailPath.append(title)
                                }
                                
                                
                                
                            }
                            
                        case .failed(let error):
                            Text(error.localizedDescription)
                                .errorMessage()
                                .frame(width: geo.size.width, height: geo.size.height)
                        }
                    }.task {
                        await viewModel.getTitles()
                    } .navigationDestination(for: Title.self) { title in
                        TitleDetailView(title: title)
                    }
                    
                
            }
        }
    }
}

#Preview {
    HomeView()
}
