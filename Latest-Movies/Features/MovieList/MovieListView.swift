//
//  MovieListView.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import SwiftUI

struct MovieListView: View {
    @ObservedObject var listViewModel: MovieListViewModel
    @ObservedObject var searchViewModel: MovieSearchViewModel
    let onSelectMovie: (Movie) -> Void

    init(
        listViewModel: MovieListViewModel,
        searchViewModel: MovieSearchViewModel,
        onSelectMovie: @escaping (Movie) -> Void
    ) {
        self.listViewModel = listViewModel
        self.searchViewModel = searchViewModel
        self.onSelectMovie = onSelectMovie
    }

    var body: some View {
        let trimmedQuery = searchViewModel.query.trimmingCharacters(in: .whitespacesAndNewlines)
        Group {
            if !trimmedQuery.isEmpty {
                MovieSearchResultsView(viewModel: searchViewModel, onSelectMovie: onSelectMovie)
            } else {
                movieList
            }
        }
        .navigationTitle(Text(NSLocalizedString("latest_movies_title", comment: "")))
        .searchable(
            text: $searchViewModel.query,
            prompt: Text(NSLocalizedString("search_movies_prompt", comment: ""))
        )
        .onChange(of: searchViewModel.query) { _, _ in
            searchViewModel.handleQueryChange()
        }
        .onSubmit(of: .search) {
            searchViewModel.performSearch()
        }
    }

    private var movieList: some View {
        List {
            ForEach(listViewModel.movies) { movie in
                Button {
                    onSelectMovie(movie)
                } label: {
                    MovieRowView(movie: movie, service: listViewModel.service)
                }
                .buttonStyle(.plain)
                .onAppear {
                    listViewModel.loadNextPageIfNeeded(currentMovie: movie)
                }
            }

            if listViewModel.isLoading && !listViewModel.movies.isEmpty {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .overlay(contentOverlay)
        .onAppear {
            listViewModel.loadInitialIfNeeded()
        }
    }

    @ViewBuilder
    private var contentOverlay: some View {
        if listViewModel.isLoading && listViewModel.movies.isEmpty {
            ProgressView(NSLocalizedString("loading_movies", comment: ""))
        } else if let errorMessage = listViewModel.errorMessage {
            ContentUnavailableView(
                NSLocalizedString("could_not_load_movies_title", comment: ""),
                systemImage: "film",
                description: Text(errorMessage)
            )
        }
    }
}
