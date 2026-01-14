//
//  NetworkError.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError
    case genericError(Error)

    var description: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .statusCode(let code):
            return "Error status code: \(code)"
        case .decodingError:
            return "Failed to decode response"
        case .genericError(let error):
            return error.localizedDescription
        }
    }
}
