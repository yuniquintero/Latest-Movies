//
//  MovieDetailView.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject var viewModel: MovieDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                headerImage
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.movie?.title ?? "Loading...")
                        .font(.title2.bold())
                }
                .padding(.horizontal)

                if let overview = viewModel.movie?.overview {
                    Text(overview)
                        .font(.body)
                        .padding(.horizontal)
                }

                detailsSection
            }
        }
        .overlay(detailOverlay)
        .navigationTitle(viewModel.movie?.title ?? "Movie")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.load()
        }
    }

    @ViewBuilder
    private var headerImage: some View {
        if let url = viewModel.service.imageURL(path: viewModel.movie?.backdropPath, size: .w500) ??
            viewModel.service.imageURL(path: viewModel.movie?.posterPath, size: .w500) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Color.gray.opacity(0.1)
                }
            }
            .frame(height: 220)
            .clipped()
        }
    }

    @ViewBuilder
    private var detailsSection: some View {
        if let movie = viewModel.movie {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    Label("\(movie.voteAverage, specifier: "%.1f")", systemImage: "star.fill")
                        .foregroundStyle(.orange)
                    if let runtime = movie.runtime {
                        Text("\(runtime) min")
                            .foregroundStyle(.secondary)
                    }
                    if let releaseDate = DateUtils.formattedReleaseDate(from: movie.releaseDate) {
                        Text(releaseDate)
                            .foregroundStyle(.secondary)
                    }
                }
                if !movie.genres.isEmpty {
                    Text(movie.genres.map { $0.name }.joined(separator: " · "))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
    }

    @ViewBuilder
    private var detailOverlay: some View {
        if viewModel.isLoading {
            ProgressView("Loading details...")
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView("Could not load details", systemImage: "film", description: Text(errorMessage))
        }
    }

}
