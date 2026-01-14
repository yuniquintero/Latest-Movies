//
//  APIClient.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 12/1/26.
//

import Foundation

protocol APIClientProtocol {
    func get<T: Decodable>(path: String, params: [String: String]) async throws -> T
    func imageURL(path: String?, size: TMDBImageSize) -> URL?
}

struct APIClient: APIClientProtocol {
    private let bearerToken: String

    init(bearerToken: String = Environment.bearerToken) {
        self.bearerToken = bearerToken
    }

    func get<T: Decodable>(path: String, params: [String: String]) async throws -> T {
        guard let base = URL(string: APIConstants.baseURL) else {
            throw NetworkError.invalidURL
        }
        let url = base.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let requestURL = components?.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }

    func imageURL(path: String?, size: TMDBImageSize = .w500) -> URL? {
        guard let path, !path.isEmpty else { return nil }
        guard let base = URL(string: APIConstants.imageBaseURL) else { return nil }
        return base.appendingPathComponent(size.rawValue).appendingPathComponent(path)
    }
}

private enum Environment {
    static let bearerToken: String = {
        guard let url = Bundle.main.url(forResource: "Environment", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
              let token = plist["TMDB_BEARER_TOKEN"] as? String,
              !token.isEmpty,
              token != "YOUR_TMDB_BEARER_TOKEN" else {
            return ""
        }
        return token
    }()
}
