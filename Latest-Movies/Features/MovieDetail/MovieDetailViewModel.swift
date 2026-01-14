//
//  MovieDetailViewModel.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import Foundation

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published private(set) var movie: MovieDetail?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    let service: MovieServiceProtocol
    private let movieId: Int

    init(service: MovieServiceProtocol, movieId: Int) {
        self.service = service
        self.movieId = movieId
    }

    func load() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            do {
                let detail = try await service.getMovieDetail(id: movieId)
                movie = detail
                isLoading = false
            } catch {
                errorMessage = "Could not load movie details. \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}
