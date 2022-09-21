//
//  HTTPClient.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-15.
//

import Foundation
import Combine

class HTTPClient {

    private var apiKeys = [
        "S2TMY93PPRKX0W8C",
        "1JTHEE9X15R84QNC",
        "RWN08773D96XUM7M",
        "L996LNUVQRLJBIZH"
    ]

    var getApiKey: String {
        return apiKeys.randomElement() ?? ""
    }

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
                .mapError({ (error) -> JSONDecodingError in
                    return JSONDecodingError(
                        errorCode: JSONDecodingError.ErrorCodes.unknown.rawValue,
                        errorUserInfo: [
                            JSONDecodingError.UserInfoKey.failure.rawValue : String(describing: error)
                        ]
                    )
                })
                .eraseToAnyPublisher()
                
        } catch {
            return Fail<Res, Error>(error: error)
                .eraseToAnyPublisher()
        }
    }
}
