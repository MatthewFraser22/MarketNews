//
//  Toggle+CheckBoxStyle.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-09-08.
//

import Foundation
import SwiftUI

struct ToggleCheckBoxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            print("testing toggle: \(configuration.isOn)")
            configuration.isOn.toggle()
        } label: {
            #warning("TODO - fix logic")
            if !configuration.isOn {
                Image(systemName: "checkmark.square.fill")
            } else {
                Image(systemName: "square")
            }
        }.foregroundColor(.blue)
    }
}

extension ToggleStyle where Self == ToggleCheckBoxStyle {
    static var checklist: ToggleCheckBoxStyle { .init() }
}
