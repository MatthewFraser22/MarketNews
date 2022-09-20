//
//  FilterSearchView.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-24.
//

import SwiftUI
import Combine

struct FilterSearchView: View {
    @ObservedObject private var filterSearchVM: FilterSearchViewModel
    @State private var isChecked: Bool = true

    private var tickerText: Text {
        return filterSearchVM.selectedTicker.isEmpty == true ? Text("Select a stock ticker") : Text("Selected:")
    }

    var client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
        filterSearchVM = FilterSearchViewModel(client: client)
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 8) {
                NavigationLink(
                    destination: SearchStockTickerView()
                        .environmentObject(filterSearchVM)
                ) {
                    tickerLabel
                }
                toggleTopic
                searchButton
            }
            .padding([.top, .bottom, .leading, .trailing], 16)
            .navigationTitle("Advanced Search")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    var tickerLabel: some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            tickerText
                .foregroundColor(.blue)
            Text(filterSearchVM.selectedTicker)
                .foregroundColor(.blue)
        }
        .padding(.bottom, 20)
    }

    var toggleTopic: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Choose a topic to search for")
                .font(.title2)
                .bold()
                .foregroundColor(.gray)
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Topics.allCases, id: \.self) { topic in
                        CheckboxView(topic: topic)
                            .environmentObject(filterSearchVM)
                    }
                }
            }
        }
        
    }

    var searchButton: some View {
        Button {
            print("tapped")
        } label: {
            ZStack {
                Color.blue
                    .cornerRadius(8)
                Text("Search")
                    .bold()
                    .foregroundColor(.white)
            }.frame(height: 50)
        }
    }
}

struct FilterSearchView_Previews: PreviewProvider {
    static var previews: some View {
        FilterSearchView(client: HTTPClient())
    }
}
