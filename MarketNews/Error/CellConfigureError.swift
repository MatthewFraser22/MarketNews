//
//  CellConfigureError.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-19.
//

import Foundation

struct CellConfigureError: CustomNSError {
    static let errorDomain: String = "com.matthewfraser.cellconfigure-error.marketnews"

    var errorCode: Int
    var errorUserInfo: [String : Any]

    enum ErrorCodes: Int {
        case unableToDequeueCell = 1
        case unableToDequeueSectionHeader = 2
    }

    enum UserInfoKey: String {
        case failureReason = "reason"
        case errorDetail = "details"
    }
}
