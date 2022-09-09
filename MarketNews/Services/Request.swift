//
//  Request.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-15.
//

import Foundation

struct Request<Body: Codable> {
    var basePathURL: String
    var httpMethod: HTTPMethod = .get
    var queryParams: [String : String] = [:]
    var body: Body?
    var headers: [String : String] = Self.defaultHeaders

    static var defaultHeaders: [String : String] {

        // configure to desired header
        return ["Content-Type" : "application/json"]
    }

    func buildURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: basePathURL) else {
            throw RequestAPIError.init(
                errorCode: RequestAPIError.ErrorCode.invalidBasePath.rawValue,
                errorUserInfo: [
                    RequestAPIError.UserInfoKey.errorDetail.rawValue : basePathURL,
                    RequestAPIError.UserInfoKey.failureReason.rawValue : "Failed to create a url from the base path"
                ]
            )
        }

        // Add Query Items
        urlComponents.queryItems = {
            var queryItems = [URLQueryItem]()

            for (name, value) in queryParams {
                let item = URLQueryItem(name: name, value: value)
                queryItems.append(item)
            }

            return queryItems
        }()

        // Create URl Request from components
        guard let url = urlComponents.url else {
            throw RequestAPIError.init(
                errorCode: RequestAPIError.ErrorCode.invalidURL.rawValue,
                errorUserInfo: [
                    RequestAPIError.UserInfoKey.errorDetail.rawValue : String(describing: urlComponents.url),
                    RequestAPIError.UserInfoKey.failureReason.rawValue : "Failed to create a url from components "
                ]
            )
        }

        var urlRequest = URLRequest(url: url)
        
        // Add the HTTPMethod
        urlRequest.httpMethod = httpMethod.rawValue
        // Add HTTP Headers
        headers.forEach { (key: String, value: String) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }

        print("Testing url request \(urlRequest.url)")
        return urlRequest
    }
}
