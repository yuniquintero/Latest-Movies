//
//  MovieSearchViewModel.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import Foundation

@MainActor
final class MovieSearchViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var results: [Movie] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    let service: MovieServiceProtocol
    private var debounceTask: Task<Void, Never>?

    init(service: MovieServiceProtocol) {
        self.service = service
    }

    func handleQueryChange() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            results = []
            isLoading = false
            errorMessage = nil
            return
        }
        scheduleSearch(for: trimmed)
    }

    func performSearch(term: String? = nil) {
        let trimmed = (term ?? query).trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else { return }
        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            do {
                let response = try await service.searchMovies(query: trimmed, page: 1)
                results = response.results.sorted { lhs, rhs in
                    let leftDate = lhs.releaseDate ?? ""
                    let rightDate = rhs.releaseDate ?? ""
                    return leftDate > rightDate
                }
                isLoading = false
            } catch {
                errorMessage = "Could not search movies. \(error.localizedDescription)"
                isLoading = false
            }
        }
    }

    private func scheduleSearch(for term: String) {
        debounceTask?.cancel()
        debounceTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000)
            performSearch(term: term)
        }
    }
}
