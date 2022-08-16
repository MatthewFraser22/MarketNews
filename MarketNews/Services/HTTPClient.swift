//
//  HTTPClient.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-15.
//

import Foundation
import Combine

class HTTPClient {

    init() {}

    func publisher<Req: Encodable, Res: Decodable>(
        for urlRequest: Request<Req>,
        response: Res.Type
    ) -> AnyPublisher<Res, Error> {
        do {
            let request = try urlRequest.buildURLRequest()

            return URLSession.shared.dataTaskPublisher(for: request)
                .timeout(.seconds(5), scheduler: RunLoop.main)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw HTTPClientError(
                            errorCode: HTTPClientError.ErrorCodes.unknown.rawValue,
                            errorUserInfo: [
                                HTTPClientError.UserInfoKey.failureReason.rawValue : "invalid url response"
                            ]
                        )
                    }

                    guard httpResponse.isSuccess else {
                        throw HTTPClientError(
                            errorCode: httpResponse.statusCode,
                            errorUserInfo: [
                                HTTPClientError.UserInfoKey.failureReason.rawValue: "Bad HTTP Status Code"
                            ]
                        )
                    }

                    return data
                }
                .decode(type: Res.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
                
        } catch {
            return Fail<Res, Error>(error: error)
                .eraseToAnyPublisher()
        }
    }
}
