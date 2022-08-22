//
//  Bundle+Extensions.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-17.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to convert contents of \(url) to data")
        }

        guard let decodedJSON = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("Failed to decode json from data")
        }

        return decodedJSON
    }
}
