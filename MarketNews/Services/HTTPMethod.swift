//
//  HTTPMethod.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-15.
//

import Foundation

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}
