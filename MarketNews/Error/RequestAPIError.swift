//
//  RequestAPIError.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-16.
//

import Foundation

struct RequestAPIError: CustomNSError {
    static let errorDomain: String = "com.matthewfraser.marketnews.requestapierror"
    var errorCode: Int
    var errorUserInfo: [String : Any]

    enum ErrorCode: Int {
        case invalidBasePath = 0
        case invalidURL = 1
    }

    enum UserInfoKey: String {
        case failureReason = "reason"
        case errorDetail = "details"
    }
}
