//
//  MarketData.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-16.
//

import Foundation

// MARK: - MarketData

struct MarketData: Codable, Hashable {
    let items: String
    let feed: [FeedItem]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode(String.self, forKey: .items)
        feed = try container.decode([FeedItem].self, forKey: .feed)
    }

    enum CodingKeys: String, CodingKey {
        case items
        case feed
    }
}

// MARK: - Feed Items

struct FeedItem: Codable, Hashable {
    let title: String
    let url: String
    let timePublished: String
    let authors: [String]
    let summary: String
    let bannerImage: String
    let source: String
    let category: String
    let topics: [TopicElement]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        url = try container.decode(String.self, forKey: .url)
        timePublished = try container.decode(String.self, forKey: .timePublished)
        authors = try container.decode([String].self, forKey: .authors)
        summary = try container.decode(String.self, forKey: .summary)
        bannerImage = try container.decode(String.self, forKey: .bannerImage)
        source = try container.decode(String.self, forKey: .source)
        category = try container.decode(String.self, forKey: .category)
        topics = try container.decode([TopicElement].self, forKey: .topics)
    }

    enum CodingKeys: String, CodingKey {
        case title
        case url
        case timePublished = "time_published"
        case authors
        case summary
        case bannerImage = "banner_image"
        case source
        case category = "category_within_source"
        case topics
    }
}

// MARK: - TopicElement

struct TopicElement: Codable, Hashable {
    let topic: String

    enum CodingKeys: String, CodingKey {
        case topic
    }
}

enum TopicEnum: String, Codable {
    case blockchain = "Blockchain"
    case earnings = "Earnings"
    case economyMacro = "Economy - Macro"
    case economyMonetary = "Economy - Monetary"
    case energyTransportation = "Energy & Transportation"
    case finance = "Finance"
    case financialMarkets = "Financial Markets"
    case lifeSciences = "Life Sciences"
    case manufacturing = "Manufacturing"
    case mergersAcquisitions = "Mergers & Acquisitions"
    case realEstateConstruction = "Real Estate & Construction"
    case retailWholesale = "Retail & Wholesale"
    case technology = "Technology"
}
