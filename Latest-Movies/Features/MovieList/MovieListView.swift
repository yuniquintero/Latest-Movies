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
    @State private var navigationPath = NavigationPath()

    init(listViewModel: MovieListViewModel, searchViewModel: MovieSearchViewModel) {
        self.listViewModel = listViewModel
        self.searchViewModel = searchViewModel
    }

    var body: some View {
        let trimmedQuery = searchViewModel.query.trimmingCharacters(in: .whitespacesAndNewlines)
        NavigationStack(path: $navigationPath) {
            Group {
                if !trimmedQuery.isEmpty {
                    MovieSearchResultsView(viewModel: searchViewModel)
                } else {
                    movieList
                }
            }
            .navigationTitle("Latest Movies")
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(viewModel: MovieDetailViewModel(service: listViewModel.service, movieId: movie.id))
            }
        }
        .searchable(text: $searchViewModel.query, prompt: "Search movies")
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
                NavigationLink(value: movie) {
                    MovieRowView(movie: movie, service: listViewModel.service)
                        .onAppear {
                            listViewModel.loadNextPageIfNeeded(currentMovie: movie)
                        }
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
            ProgressView("Loading movies...")
        } else if let errorMessage = listViewModel.errorMessage {
            ContentUnavailableView("Could not load movies", systemImage: "film", description: Text(errorMessage))
        }
    }
}
