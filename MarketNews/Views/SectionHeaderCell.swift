//
//  File.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-24.
//

import Foundation
import UIKit

class SectionHeaderCell: UICollectionReusableView {
    static var reuseIdentifier: String = "sectionHeaderCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        let seperator = UIView(frame: .zero)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = .tertiaryLabel
        
        print("TEsting adding sub view")
        addSubview(seperator)
        NSLayoutConstraint.activate([
            seperator.heightAnchor.constraint(equalToConstant: 1),
            seperator.leadingAnchor.constraint(equalTo: leadingAnchor),
            seperator.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
