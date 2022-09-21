//
//  String+Extensions.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-19.
//

import Foundation
import UIKit

extension String {
    func stringToUIImage() -> Result<UIImage, Error> {
        guard let url = URL(string: self) else {
            return .failure(
                URLError.init(
                    errorCode: URLError.ErrorCodes.failedToConvertURLToData.rawValue,
                    errorUserInfo: [
                        URLError.UserInfoKey.errorDetail.rawValue : String(describing: self),
                        URLError.UserInfoKey.failureReason.rawValue : "unable to make url from string: \(self)"
                    ])
            )
        }

        do {
            let data = try Data(contentsOf: url)

            guard let image = UIImage(data: data) else {
                return .failure(
                    URLError.init(
                        errorCode: URLError.ErrorCodes.failedToMakeImageFromData.rawValue,
                        errorUserInfo: [
                            URLError.UserInfoKey.failureReason.rawValue : "unable to make image from data"
                        ])
                )
            }

            return .success(image)
        } catch {
            return .failure(
                URLError.init(
                    errorCode: URLError.ErrorCodes.failedToConvertURLToData.rawValue,
                    errorUserInfo: [
                        URLError.UserInfoKey.failureReason.rawValue : "failed to turn url: \(url) to data"
                    ])
            )
        }
        
    }

    func customDate() -> String {
        let year = self.prefix(4)
        var monthString = "\(self[4])\(self[5])"
        let day = "\(self[6])\(self[7])"
        let months = Month.allCases

        if monthString[0] == "0" { monthString = monthString[1].toString }

        var monthInt = monthString.toInt ?? 0

        if monthInt != 0 {
            monthInt = monthInt - 1
        }

        let month = months[monthInt]
        let formattedDate = "\(month) \(day), \(year)"

        return formattedDate
    }

    var toInt: Int? {
        return Int(self)
    }

    // MARK: - Subscripts

    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }

    // MARK: - Enums

    private enum Month: String, CaseIterable {
        case Janurary
        case Feburary
        case March
        case April
        case May
        case June
        case July
        case August
        case September
        case October
        case November
        case December
    }
}
