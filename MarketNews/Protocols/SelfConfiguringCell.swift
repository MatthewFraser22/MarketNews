//
//  SelfConfiguringCell.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-17.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(item: NewsArticleItem)
}
