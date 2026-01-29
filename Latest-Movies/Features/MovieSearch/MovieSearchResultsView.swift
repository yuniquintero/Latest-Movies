//
//  MovieSearchResultsView.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import SwiftUI

struct MovieSearchResultsView: View {
    @ObservedObject var viewModel: MovieSearchViewModel
    let onSelectMovie: (Movie) -> Void

    var body: some View {
        List {
            ForEach(viewModel.results) { movie in
                Button {
                    onSelectMovie(movie)
                } label: {
                    MovieRowView(movie: movie, service: viewModel.service)
                        .accessibilityHint(
                            Text(
                                NSLocalizedString(
                                    "opens_movie_details_accessibility_hint",
                                    comment: ""
                                )
                            )
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .listStyle(.plain)
        .overlay(resultsOverlay)
    }

    @ViewBuilder
    private var resultsOverlay: some View {
        if viewModel.isLoading {
            ProgressView(NSLocalizedString("searching", comment: ""))
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView(
                NSLocalizedString("search_failed_title", comment: ""),
                systemImage: "magnifyingglass",
                description: Text(errorMessage)
            )
        } else if viewModel.results.isEmpty {
            ContentUnavailableView(
                NSLocalizedString("no_results_title", comment: ""),
                systemImage: "magnifyingglass",
                description: Text(
                    NSLocalizedString(
                        "try_another_title_message",
                        comment: ""
                    )
                )
            )
        }
    }
}
