//
//  MovieDetail.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import Foundation

// MARK: - DTOs

struct MovieDetailDTO: Identifiable, Decodable {
    struct GenreDTO: Identifiable, Decodable {
        let id: Int
        let name: String
    }

    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let runtime: Int?
    let genres: [GenreDTO]

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case runtime
        case genres
    }
}

// MARK: - Domain

struct MovieDetail: Identifiable {
    struct Genre: Identifiable, Hashable {
        let id: Int
        let name: String
    }

    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let runtime: Int?
    let genres: [Genre]

    init(
        id: Int,
        title: String,
        overview: String,
        posterPath: String?,
        backdropPath: String?,
        releaseDate: String?,
        voteAverage: Double,
        runtime: Int?,
        genres: [Genre]
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.runtime = runtime
        self.genres = genres
    }

    init(from dto: MovieDetailDTO) {
        self.init(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            releaseDate: dto.releaseDate,
            voteAverage: dto.voteAverage,
            runtime: dto.runtime,
            genres: dto.genres.map { Genre(id: $0.id, name: $0.name) }
        )
    }
}
