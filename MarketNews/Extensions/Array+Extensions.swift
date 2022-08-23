//
//  Array+Extensions.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-17.
//

import Foundation

extension Array where Element == String {
    func toString() -> String {
        var stringArray = String()

        for (index, value) in self.enumerated() {
            stringArray.append(value)

            guard index + 1 < stringArray.count else { return stringArray }

            stringArray.append(" ")

        }

        return stringArray
    }
}
