//
//  FilterSearchView.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-24.
//

import SwiftUI

class ViewModel {
    
    init () {}
    
    func preformSearch() {
        
    }

}

enum ExampleTickers: String, Identifiable, CaseIterable {
    var id: UUID { UUID() }

    case tesla = "TSLA"
    case apple = "AAPL"
    case google = "GGLE"
    case amazon = "AMAZ"
    case patterson = "PTSN"
}

struct FilterSearchView: View {
    @State private var ticker: String = String()

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 4) {
                selectTicker
                Spacer()
            }
            .padding([.top, .bottom, .leading, .trailing], 16)
            .navigationTitle("Advanced Search")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    var selectTicker: some View {
        VStack(alignment: .center, spacing: 4) {
            Picker("Enter the ticker to search for", selection: $ticker) {
                ForEach(ExampleTickers.allCases, id: \.id) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.inline)
            .colorMultiply(.blue)
            Text("Ticker Selected: \(ticker)")
        }
    }

//    var selectTopic: some View {
//        checkbox
//    }

//    var searchButton: some View {
//
//    }
}

struct FilterSearchView_Previews: PreviewProvider {
    static var previews: some View {
        FilterSearchView()
    }
}
