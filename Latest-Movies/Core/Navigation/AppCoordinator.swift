//
//  AppCoordinator.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 29/1/26.
//

import SwiftUI

enum AppRoute: Hashable {
    case movieDetail(Movie)
}

@MainActor
final class AppCoordinator: ObservableObject {
    let service: MovieServiceProtocol
    @Published var path = NavigationPath()

    init(service: MovieServiceProtocol) {
        self.service = service
    }

    func showMovieDetail(for movie: Movie) {
        path.append(AppRoute.movieDetail(movie))
    }
}

struct AppCoordinatorView: View {
    @StateObject private var coordinator: AppCoordinator
    @StateObject private var listViewModel: MovieListViewModel
    @StateObject private var searchViewModel: MovieSearchViewModel

    init() {
        let service = MovieService(apiClient: APIClient())
        let coordinator = AppCoordinator(service: service)
        _coordinator = StateObject(wrappedValue: coordinator)
        _listViewModel = StateObject(wrappedValue: MovieListViewModel(service: service))
        _searchViewModel = StateObject(wrappedValue: MovieSearchViewModel(service: service))
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            MovieListView(
                listViewModel: listViewModel,
                searchViewModel: searchViewModel,
                onSelectMovie: { movie in
                    coordinator.showMovieDetail(for: movie)
                }
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .movieDetail(let movie):
                    MovieDetailView(
                        viewModel: MovieDetailViewModel(
                            service: coordinator.service,
                            movieId: movie.id
                        )
                    )
                }
            }
        }
    }
}

