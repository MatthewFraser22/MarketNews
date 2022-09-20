//
//  CheckListItem.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-09-08.
//

import Foundation

struct CheckListItem: Identifiable {
    var id: Int
    var isChecked: Bool
    var topic: Topics
}
