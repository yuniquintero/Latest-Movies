//
//  MovieService.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import Foundation

enum TMDBImageSize: String {
    case w500
}

protocol MovieServiceProtocol {
    func getNowPlaying(page: Int) async throws -> MoviePage
    func getMovieDetail(id: Int) async throws -> MovieDetail
    func searchMovies(query: String, page: Int) async throws -> MoviePage
    func imageURL(path: String?, size: TMDBImageSize) -> URL?
}

struct MovieService: MovieServiceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getNowPlaying(page: Int) async throws -> MoviePage {
        let params: [String: String] = [
            "page": String(page),
            "language": "en-US"
        ]
        let dto: MovieListResponseDTO = try await apiClient.get(path: APIConstants.nowPlayingPath, params: params)
        let movies = dto.results.map(Movie.init)
        return MoviePage(page: dto.page, movies: movies, totalPages: dto.totalPages)
    }

    func getMovieDetail(id: Int) async throws -> MovieDetail {
        let params: [String: String] = [
            "language": "en-US"
        ]
        let path = APIConstants.movieDetailPath + "/\(id)"
        let dto: MovieDetailDTO = try await apiClient.get(path: path, params: params)
        return MovieDetail(from: dto)
    }

    func searchMovies(query: String, page: Int) async throws -> MoviePage {
        let params: [String: String] = [
            "query": query,
            "page": String(page),
            "include_adult": "false",
            "language": "en-US"
        ]
        let dto: MovieListResponseDTO = try await apiClient.get(path: APIConstants.searchPath, params: params)
        let movies = dto.results.map(Movie.init)
        return MoviePage(page: dto.page, movies: movies, totalPages: dto.totalPages)
    }

    func imageURL(path: String?, size: TMDBImageSize = .w500) -> URL? {
        apiClient.imageURL(path: path, size: size)
    }
}
