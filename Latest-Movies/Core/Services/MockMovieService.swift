//
//  MockMovieService.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import Foundation

struct MockMovieService: MovieServiceProtocol {
    let apiClient: APIClientProtocol
    var nowPlayingResult: Result<MoviePage, Error> = .success(MoviePage(page: 1, movies: [], totalPages: 1))
    var detailResult: Result<MovieDetail, Error> = .failure(NetworkError.invalidResponse)
    var searchResult: Result<MoviePage, Error> = .success(MoviePage(page: 1, movies: [], totalPages: 1))

    init(
        apiClient: APIClientProtocol,
        nowPlayingResult: Result<MoviePage, Error> = .success(MoviePage(page: 1, movies: [], totalPages: 1)),
        detailResult: Result<MovieDetail, Error> = .failure(NetworkError.invalidResponse),
        searchResult: Result<MoviePage, Error> = .success(MoviePage(page: 1, movies: [], totalPages: 1))
    ) {
        self.apiClient = apiClient
        self.nowPlayingResult = nowPlayingResult
        self.detailResult = detailResult
        self.searchResult = searchResult
    }

    func getNowPlaying(page: Int) async throws -> MoviePage {
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

    func searchMovies(query: String, page: Int) async throws -> MoviePage {
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
