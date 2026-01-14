//
//  MovieListViewModel.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import Foundation

@MainActor
final class MovieListViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

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
        guard !isLoading, page <= totalPages else { return }
        isLoading = true
        errorMessage = nil

        do {
            let response = try await service.getNowPlaying(page: page)
            movies.append(contentsOf: response.results)
            page += 1
            totalPages = response.totalPages
            isLoading = false
        } catch {
            errorMessage = "Could not load movies. \(error.localizedDescription)"
            isLoading = false
        }
    }
}
