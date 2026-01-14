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
    func getNowPlaying(page: Int) async throws -> MovieListResponse
    func getMovieDetail(id: Int) async throws -> MovieDetail
    func searchMovies(query: String, page: Int) async throws -> MovieListResponse
    func imageURL(path: String?, size: TMDBImageSize) -> URL?
}

struct MovieService: MovieServiceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getNowPlaying(page: Int) async throws -> MovieListResponse {
        let params: [String: String] = [
            "page": String(page),
            "language": "en-US"
        ]
        return try await apiClient.get(path: APIConstants.nowPlayingPath, params: params)
    }

    func getMovieDetail(id: Int) async throws -> MovieDetail {
        let params: [String: String] = [
            "language": "en-US"
        ]
        let path = APIConstants.movieDetailPath + "/\(id)"
        return try await apiClient.get(path: path, params: params)
    }

    func searchMovies(query: String, page: Int) async throws -> MovieListResponse {
        let params: [String: String] = [
            "query": query,
            "page": String(page),
            "include_adult": "false",
            "language": "en-US"
        ]
        return try await apiClient.get(path: APIConstants.searchPath, params: params)
    }

    func imageURL(path: String?, size: TMDBImageSize = .w500) -> URL? {
        apiClient.imageURL(path: path, size: size)
    }
}
