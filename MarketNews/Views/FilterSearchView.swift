//
//  FilterSearchView.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-24.
//

import SwiftUI
import Combine

class FilterSearchViewModel: ObservableObject {

    // MARK: Properties

    var client: HTTPClient
    private var cancellable = Set<AnyCancellable>()
    @Published var selectedTopic: Topics = .technology
    @Published var searchQuery: String = String()
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

struct FilterSearchView: View {
    @ObservedObject private var filterSearchVM: FilterSearchViewModel
    @State private var isChecked: Bool = true

    var client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
        filterSearchVM = FilterSearchViewModel(client: client)
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 2) {
                tickerTextfield
                listTickersForSearchQuery
                Spacer()
                toggleTopic
            }
            .padding([.top, .bottom, .leading, .trailing], 16)
            .navigationTitle("Advanced Search")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    var tickerTextfield: some View {
        TextField("Enter a ticker to search for", text: $filterSearchVM.searchQuery)
            .textFieldStyle(.roundedBorder)
            .foregroundColor(.gray) // text color = gray
            .textInputAutocapitalization(.characters)
            .padding()
    }

    var listTickersForSearchQuery: some View {
        List(filterSearchVM.searchResult) {
            Text($0.symbol)
        }
        .foregroundColor(.blue)
        .listStyle(.inset) //inset
    }

//    var topicTextField: some View {
//        VStack {
//            Text("Enter a topic to seach for: ")
//                .font(.headline)
//                .fontWeight(.bold)
//            ForEach(Topics.allCases, id: \.self) { name in
//                Text(name.rawValue)
//                    .font(.subheadline)
//            }
//        }
//    }

    var toggleTopic: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(Topics.allCases, id: \.self) { name in
                HStack {
                    Toggle(name.rawValue, isOn: $isChecked)
                        .labelsHidden()
                        .toggleStyle(.checklist)
                        .font(.title)
                    Text(name.rawValue)
                }
            }
            
        }.padding()
        
    }
}

struct FilterSearchView_Previews: PreviewProvider {
    static var previews: some View {
        FilterSearchView(client: HTTPClient())
    }
}
