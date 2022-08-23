//
//  JSONDecodingError.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-17.
//

import Foundation

struct JSONDecodingError: CustomNSError {

    static var errorDomain: String = "com.matthewfraser.marketnews.httpclient"
    var errorCode: Int
    var errorUserInfo: [String : Any]

    enum ErrorCodes: Int {
        case unknown = 999
    }

    enum UserInfoKey: String {
        case failure = "reason"
    }
}
