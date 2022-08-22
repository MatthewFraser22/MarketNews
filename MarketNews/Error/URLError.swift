//
//  URLError.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-19.
//

import Foundation

struct URLError: CustomNSError {
    static let errorDomain: String = "com.matthewfraser.urlerror.marketnews"

    var errorCode: Int
    var errorUserInfo: [String : Any]

    enum ErrorCodes: Int {
        case failedToMakeURLFromString = 0
        case failedToMakeImageFromData = 1
        case failedToConvertURLToData = 2
    }

    enum UserInfoKey: String {
        case failureReason = "reason"
        case errorDetail = "details"
    }
}
