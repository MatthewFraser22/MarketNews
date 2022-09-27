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
    private var cancellables = Set<AnyCancellable>()
    @Published var selectedTopic: Topics?
    @Published var selectedTicker: String = ""
    @Published var searchQuery: String = String()
    @Published var canSelectTopic: Bool = true
    @Published var searchResult: [SearchResult] = [
        SearchResult(symbol: "", currency: "", name: "", type: "")
    ]

    var canProceedAdvancedSearch: Bool {
        selectedTopic != nil && !selectedTicker.isEmpty
    }

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
                    for: self.getSymbolsRequest(keywords: output),
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
                }.store(in: &self.cancellables)
            }.store(in: &self.cancellables)
    }

    func checkBoxButtonPressed(isChecked: inout Bool, topic: Topics) {

        guard isChecked == true || canSelectTopic == true else { return }

        isChecked = !isChecked

        if isChecked {
            selectedTopic = topic
            canSelectTopic = false
        } else {
            selectedTopic = nil
            canSelectTopic = true
        }
    }
    
    func searchButtonPressed() {
        
    }

    func preformAdvancedSearch() {
        self.client.publisher(
            for: getRequest(),
            response: MarketData.self
        ).sink { completion in
            switch completion {
            case .finished:
                break
            case let .failure(error):
                print(error)
            }
        } receiveValue: { marketData in
            
        }.store(in: &cancellables)

    }

    func getRequest() -> Request<EmptyRequest> {
        Request(
            basePathURL: "https://www.alphavantage.co/query",
            httpMethod: .get,
            queryParams: [
                "function" : "NEWS_SENTIMENT",
                "tickers" : selectedTicker,
                "topics" : selectedTopic?.rawValue ?? Topics.technology.rawValue,
                "apikey" : client.getApiKey
            ],
            body: nil
        )
    }

    private func getSymbolsRequest(keywords: String) -> Request<EmptyRequest> {
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
