//
//  MockMovieService.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import Foundation

struct MockMovieService: MovieServiceProtocol {
    let apiClient: APIClientProtocol
    var nowPlayingResult: Result<MovieListResponse, Error> = .success(MovieListResponse(page: 1, results: [], totalPages: 1))
    var detailResult: Result<MovieDetail, Error> = .failure(NetworkError.invalidResponse)
    var searchResult: Result<MovieListResponse, Error> = .success(MovieListResponse(page: 1, results: [], totalPages: 1))

    init(
        apiClient: APIClientProtocol,
        nowPlayingResult: Result<MovieListResponse, Error> = .success(MovieListResponse(page: 1, results: [], totalPages: 1)),
        detailResult: Result<MovieDetail, Error> = .failure(NetworkError.invalidResponse),
        searchResult: Result<MovieListResponse, Error> = .success(MovieListResponse(page: 1, results: [], totalPages: 1))
    ) {
        self.apiClient = apiClient
        self.nowPlayingResult = nowPlayingResult
        self.detailResult = detailResult
        self.searchResult = searchResult
    }

    func getNowPlaying(page: Int) async throws -> MovieListResponse {
        switch nowPlayingResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }

    func getMovieDetail(id: Int) async throws -> MovieDetail {
        switch detailResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }

    func searchMovies(query: String, page: Int) async throws -> MovieListResponse {
        switch searchResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }

    func imageURL(path: String?, size: TMDBImageSize = .w500) -> URL? {
        apiClient.imageURL(path: path, size: size)
    }
}
