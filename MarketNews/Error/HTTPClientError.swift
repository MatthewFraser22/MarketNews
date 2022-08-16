//
//  HTTPClientError.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-16.
//

import Foundation

struct HTTPClientError: CustomNSError {
    static let errorDomain: String = "com.matthewfraser.marketnews.httpclient"
    var errorCode: Int
    var errorUserInfo: [String : Any]

    enum ErrorCodes: Int {
        case unknown = 999
    }

    enum UserInfoKey: String {
        case failureReason = "reason"
    }
}
