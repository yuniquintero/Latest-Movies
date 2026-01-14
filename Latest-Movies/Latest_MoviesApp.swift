//
//  Latest_MoviesApp.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import SwiftUI

@main
struct Latest_MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            let service = MovieService(apiClient: APIClient())
            MovieListView(
                listViewModel: MovieListViewModel(service: service),
                searchViewModel: MovieSearchViewModel(service: service)
            )
        }
    }
}
