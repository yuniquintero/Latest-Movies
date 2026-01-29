//
//  MovieRowView.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    let service: MovieServiceProtocol

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            poster
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                if let year = DateUtils.formattedYear(from: movie.releaseDate) {
                    Text(year)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Text(movie.overview)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(movie.title))
    }

    private var poster: some View {
        Group {
            if let url = service.imageURL(path: movie.posterPath, size: .w500) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .accessibilityLabel(
                                Text(
                                    NSLocalizedString(
                                        "movie_poster_accessibility_label",
                                        comment: ""
                                    )
                                )
                            )
                    default:
                        Color.gray.opacity(0.1)
                    }
                }
            } else {
                Color.gray.opacity(0.1)
            }
        }
        .frame(width: 70, height: 105)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
