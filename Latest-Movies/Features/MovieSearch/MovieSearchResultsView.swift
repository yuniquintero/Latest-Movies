//
//  MovieSearchResultsView.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import SwiftUI

struct MovieSearchResultsView: View {
    @ObservedObject var viewModel: MovieSearchViewModel

    var body: some View {
        List {
            ForEach(viewModel.results) { movie in
                NavigationLink(value: movie) {
                    MovieRowView(movie: movie, service: viewModel.service)
                }
            }
        }
        .listStyle(.plain)
        .overlay(resultsOverlay)
    }

    @ViewBuilder
    private var resultsOverlay: some View {
        if viewModel.isLoading {
            ProgressView("Searching...")
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView("Search failed", systemImage: "magnifyingglass", description: Text(errorMessage))
        } else if viewModel.results.isEmpty {
            ContentUnavailableView("No results", systemImage: "magnifyingglass", description: Text("Try another title."))
        }
    }
}
