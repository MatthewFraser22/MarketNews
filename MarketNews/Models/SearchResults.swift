//
//  SearchResults.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-25.
//

import Foundation

struct SearchResults: Codable {
    var results: [SearchResult]

    enum CodingKeys: String, CodingKey {
        case results = "bestMatches"
    }
}

struct SearchResult: Codable, Identifiable {
    var id: UUID = UUID()

    var symbol: String
    var currency: String
    var name: String
    var type: String

    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
        case type = "3. type"
        case currency = "8. currency"
    }
}
