//
//  MovieListViewModel.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import Foundation

@MainActor
final class MovieListViewModel: ObservableObject {
    struct State {
        var movies: [Movie] = []
        var isLoading: Bool = false
        var errorMessage: String?
    }

    @Published private(set) var state = State()

    var movies: [Movie] { state.movies }
    var isLoading: Bool { state.isLoading }
    var errorMessage: String? { state.errorMessage }

    let service: MovieServiceProtocol
    private var page = 1
    private var totalPages = 1

    init(service: MovieServiceProtocol) {
        self.service = service
    }

    func loadInitialIfNeeded() {
        guard movies.isEmpty else { return }
        loadNextPage()
    }

    func loadNextPageIfNeeded(currentMovie: Movie?) {
        guard let currentMovie else {
            loadNextPage()
            return
        }

        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -6, limitedBy: movies.startIndex) ?? movies.startIndex
        if movies.firstIndex(where: { $0.id == currentMovie.id }) == thresholdIndex {
            loadNextPage()
        }
    }

    func loadNextPage() {
        Task { @MainActor in
            await loadNextPageAsync()
        }
    }

    func loadNextPageAsync() async {
        guard !state.isLoading, page <= totalPages else { return }
        state.isLoading = true
        state.errorMessage = nil

        do {
            let response = try await service.getNowPlaying(page: page)
            state.movies.append(contentsOf: response.movies)
            page += 1
            totalPages = response.totalPages
            state.isLoading = false
        } catch {
            let format = NSLocalizedString(
                "could_not_load_movies_with_error",
                comment: ""
            )
            state.errorMessage = String(format: format, error.localizedDescription)
            state.isLoading = false
        }
    }
}
