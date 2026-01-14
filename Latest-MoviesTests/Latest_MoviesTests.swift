//
//  Latest_MoviesTests.swift
//  Latest-MoviesTests
//
//  Created by Yuni Quintero on 12/1/26.
//

import XCTest
@testable import Latest_Movies

final class Latest_MoviesTests: XCTestCase {

    @MainActor
    func testMovieListViewModelLoadsDisneyMovies() async throws {
        let movies = [
            Movie(id: 1, title: "The Lion King", overview: "", posterPath: nil, backdropPath: nil, releaseDate: "1994-06-24", voteAverage: 8.5),
            Movie(id: 2, title: "Aladdin", overview: "", posterPath: nil, backdropPath: nil, releaseDate: "1992-11-25", voteAverage: 8.0),
            Movie(id: 3, title: "Beauty and the Beast", overview: "", posterPath: nil, backdropPath: nil, releaseDate: "1991-11-22", voteAverage: 8.1),
            Movie(id: 4, title: "Mulan", overview: "", posterPath: nil, backdropPath: nil, releaseDate: "1998-06-19", voteAverage: 7.9),
            Movie(id: 5, title: "Frozen", overview: "", posterPath: nil, backdropPath: nil, releaseDate: "2013-11-27", voteAverage: 7.4)
        ]
        let response = MovieListResponse(page: 1, results: movies, totalPages: 1)
        let service = MockMovieService(
            apiClient: APIClient(bearerToken: "test"),
            nowPlayingResult: .success(response)
        )
        let viewModel = MovieListViewModel(service: service)

        await viewModel.loadNextPageAsync()

        XCTAssertEqual(viewModel.movies.count, 5)
        XCTAssertEqual(viewModel.movies.map { $0.title }, movies.map { $0.title })
        XCTAssertNil(viewModel.errorMessage)
    }

    @MainActor
    func testMovieListViewModelHandlesError() async throws {
        let service = MockMovieService(
            apiClient: APIClient(bearerToken: "test"),
            nowPlayingResult: .failure(NetworkError.invalidResponse)
        )
        let viewModel = MovieListViewModel(service: service)

        await viewModel.loadNextPageAsync()

        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.errorMessage?.contains("Could not load movies") == true)
        XCTAssertTrue(viewModel.movies.isEmpty)
    }

}
