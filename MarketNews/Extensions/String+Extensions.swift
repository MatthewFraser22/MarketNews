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
}
