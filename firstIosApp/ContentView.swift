//
//  ContentView.swift
//  firstIosApp
//
//  Created by Kishore Kumar on 04/04/26.
//

import SwiftUI 

struct ContentView: View {
    var body: some View {
        TabView{
            Tab(AppConstants.homeString,systemImage: AppConstants.homeIconString){
                HomeView()
            }
            Tab(AppConstants.upcomingString,systemImage: AppConstants.upcomingIconString){
                UpcomingView()
            }
            Tab(AppConstants.searchString,systemImage: AppConstants.searchIconString){
                Text(AppConstants.searchString)
            }
            Tab(AppConstants.downloadString,systemImage: AppConstants.downloadIconString){
                Text(AppConstants.downloadString)
            }
        }
    }
}

#Preview {
    ContentView()
}
