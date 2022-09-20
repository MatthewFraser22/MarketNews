//
//  FilterSearchViewModel.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-09-08.
//
import Foundation
import Combine

class FilterSearchViewModel: ObservableObject {

    // MARK: Properties

    var client: HTTPClient
    private var cancellable = Set<AnyCancellable>()
    @Published var selectedTopic: Topics = .technology
    @Published var searchQuery: String = String()
    @Published var selectedTicker: String = ""
    @Published var searchResult: [SearchResult] = [
        SearchResult(symbol: "", currency: "", name: "", type: "")
    ]

    // MARK: - Initializer

    init(client: HTTPClient) {
        self.client = client
        startObservers()
    }

    // MARK: Helper Functions

    func startObservers() {
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] output in

                guard !output.isEmpty else { return }

                self.client.publisher(
                    for: self.getRequest(keywords: output),
                    response: SearchResults.self
                ).sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        print(error)
                    }
                } receiveValue: { [weak self] searchResults in
                    self?.searchResult = searchResults.results
                }.store(in: &self.cancellable)
            }.store(in: &self.cancellable)
    }

    private func getRequest(keywords: String) -> Request<EmptyRequest> {
        Request(
            basePathURL: "https://www.alphavantage.co/query",
            httpMethod: .get,
            queryParams: [
                "function" : "SYMBOL_SEARCH",
                "keywords" : keywords,
                "apikey" : client.getApiKey
            ],
            body: nil
        )
    }
}
