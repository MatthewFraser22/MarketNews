//
//  SearchStockTickerView.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-09-09.
//

import SwiftUI

struct SearchStockTickerView: View {
    @EnvironmentObject var filterSearchVM: FilterSearchViewModel
    @Environment(\.presentationMode) private var presentationMode

    init() {}

    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            tickerTextfield
            placeholderText
            Spacer()
        }.navigationTitle("TickerSearchView")
    }

    var tickerTextfield: some View {
        TextField("🔍Enter a ticker to search for", text: $filterSearchVM.searchQuery)
            .textFieldStyle(.roundedBorder)
            .foregroundColor(.gray) // text color = gray
            .textInputAutocapitalization(.characters)
            .padding()
    }

    var placeholderText: some View {
        if filterSearchVM.searchQuery.isEmpty {
            return AnyView(
                VStack(alignment: .center) {
                    Spacer()
                    Text("Find a stock ticker")
                        .font(.title)
                        .foregroundColor(Color(uiColor: .gray))
                        .bold()
                    Text("Start by searching for a stock ticker")
                        .font(.subheadline)
                        .foregroundColor(Color(uiColor: .systemGray))
                    Spacer()
                }.padding([.top], 20)
            )
        } else {
            return AnyView(listTickersForSearchQuery)
        }
    }

    var listTickersForSearchQuery: some View {
        List(filterSearchVM.searchResult) { searchResult in
            Button {
                filterSearchVM.selectedTicker = searchResult.symbol
                #warning("Replace with the new environment isPresented")
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text(searchResult.symbol)
            }
        }
        .padding([.bottom], 10)
        .foregroundColor(.blue)
        .listStyle(.plain) //inset
    }

}
