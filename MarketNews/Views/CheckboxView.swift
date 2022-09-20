//
//  CheckboxView.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-09-08.
//

import Foundation
import SwiftUI

struct CheckboxView: View {
    @State var isChecked: Bool = false
    var topic: Topics

    init(topic: Topics) {
        self.topic = topic
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Toggle("", isOn: $isChecked)
                .labelsHidden()
                .toggleStyle(.checklist)
            Text(topic.rawValue)
                .font(.headline)
        }.padding([.leading, .trailing, .top], 4)
    }
}
