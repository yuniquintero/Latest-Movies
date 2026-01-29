//
//  Movie.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import Foundation

// MARK: - Data transfer objects (DTOs) used only in the data layer

struct MovieListResponseDTO: Decodable {
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int

    private enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
    }
}

struct MovieDTO: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

// MARK: - Domain models used by ViewModels and Views

struct Movie: Identifiable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double

    init(
        id: Int,
        title: String,
        overview: String,
        posterPath: String?,
        backdropPath: String?,
        releaseDate: String?,
        voteAverage: Double
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
    }

    init(from dto: MovieDTO) {
        self.init(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            releaseDate: dto.releaseDate,
            voteAverage: dto.voteAverage
        )
    }
}

struct MoviePage {
    let page: Int
    let movies: [Movie]
    let totalPages: Int
}
