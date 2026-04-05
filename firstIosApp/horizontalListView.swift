//
//  horizontalListView.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 05/04/26.
//

import SwiftUI

struct horizontalListView: View {
    let header :String
    var titles = [AppConstants.testTitleURL, AppConstants.testTitleURL2, AppConstants.testTitleURL3]
    
    var body: some View {
        VStack(alignment: .leading,){
            Text(header).font(.title)
            ScrollView(.horizontal){
                LazyHStack{
                    ForEach(titles, id: \.self){
                        title in AsyncImage(url: URL(string: title)){
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
    horizontalListView(header:  AppConstants.trendingMovieString)
}
