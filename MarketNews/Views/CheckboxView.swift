//
//  CheckboxView.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-09-08.
//

import Foundation
import SwiftUI

struct CheckboxView: View {
    @EnvironmentObject private var filterVM: FilterSearchViewModel
    @State private var isChecked: Bool = false

    var topic: Topics

    init(topic: Topics) {
        self.topic = topic
    }

    var body: some View {
        HStack {
            Button {
                filterVM.checkBoxButtonPressed(isChecked: &isChecked, topic: topic)
                print(isChecked)
            } label: {
                if isChecked {
                    Image(systemName: "checkmark.square.fill")
                } else {
                    Image(systemName: "square")
                }
            }.foregroundColor(.blue)
            Text(topic.rawValue)
        }
        
    }
}
