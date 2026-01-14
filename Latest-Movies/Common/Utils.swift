//
//  Utils.swift
//  Latest-Movies
//
//  Created by Yuni Quintero on 13/1/26.
//

import Foundation

enum DateUtils {
    static func formattedYear(from rawValue: String?) -> String? {
        guard let rawValue, !rawValue.isEmpty else { return nil }
        let parser = DateFormatter()
        parser.locale = Locale(identifier: "en_US_POSIX")
        parser.dateFormat = "yyyy-MM-dd"
        guard let date = parser.date(from: rawValue) else { return nil }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }

    static func formattedReleaseDate(from rawValue: String?) -> String? {
        guard let rawValue, !rawValue.isEmpty else { return nil }
        let parser = DateFormatter()
        parser.locale = Locale(identifier: "en_US_POSIX")
        parser.dateFormat = "yyyy-MM-dd"
        guard let date = parser.date(from: rawValue) else { return nil }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}
