//
//  SearchView.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 08/04/26.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchByMovies = true
    @State private var searchText = ""
    private let searchViewModel = SearchViewModel()
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath){
            ScrollView{
                if let error = searchViewModel.errorMessage {
                                   Text(error)
                                       .foregroundStyle(.red)
                                       .padding()
                                       .background(.ultraThinMaterial)
                                       .clipShape(.rect(cornerRadius: 10))
                               }
                               
                LazyVGrid(columns: [GridItem(),GridItem(),GridItem()]) {
                    ForEach(searchViewModel.searchTitles) { title in
                                        AsyncImage(url: title.posterURL){ image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(.rect(cornerRadius: 10))
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 120, height: 200)
                                        .onTapGesture {
                                            navigationPath.append(title)
                                        }
                                    }
                                }
            } .navigationTitle(searchByMovies ? AppConstants.movieSearchString : AppConstants.tvSearchString)
                .toolbar {
                               ToolbarItem(placement: .topBarTrailing) {
                                   Button {
                                       searchByMovies.toggle()
                                       
                                       Task {
                                           await searchViewModel.getSearchTitles(by: searchByMovies ? "movies" : "shows", for: searchText)
                                       }
                                       
                                   } label: {
                                       Image(systemName: searchByMovies ? AppConstants.movieIconString : AppConstants.tvIconString)
                                   }
                               }
                }.searchable(text: $searchText, prompt: searchByMovies ? AppConstants.moviePlaceHolderString : AppConstants.tvPlaceHolderString)
                .task(id: searchText) {
                               try? await Task.sleep(for: .milliseconds(500))
                               
                               if Task.isCancelled {
                                   return
                               }
                               
                    await searchViewModel.getSearchTitles(
                        by: searchByMovies
                            ? searchText.isEmpty ? "movies" : "movie"
                            : searchText.isEmpty ? "shows" : "show",
                        for: searchText
                    )
                           }
        }
    }
}

#Preview {
    SearchView()
}
