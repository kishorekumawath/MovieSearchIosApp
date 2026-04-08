//
//  UpcomingMovies.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 08/04/26.
//

import SwiftUI


struct UpcomingView: View {
    let viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            Text("UpComing")
            GeometryReader { geo in
                switch viewModel.upcomingStatus {
                case .notStarted:
                    EmptyView()
                case .fetching:
                    ProgressView()
                        .frame(width: geo.size.width, height: geo.size.height)
                case .success:
                    VerticalListView(titles: viewModel.upcomingMovies, canDelete: false)
                case .failed(let underlyingError):
                    Text(underlyingError.localizedDescription)
                        .errorMessage()
                        .frame(width: geo.size.width, height: geo.size.height)
                }
            }
            .task {
                await viewModel.getUpcomingMovies()
            }
        }
        
    }
}

#Preview {
    UpcomingView()
}
