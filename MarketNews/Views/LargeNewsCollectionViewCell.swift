//
//  LargeNewsCollectionViewCell.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-17.
//

import Foundation
import UIKit

class LargeNewsCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "largeNewsCollectionViewCell"

    // MARK: - Properties

    var sourceLabel = UILabel()
    var articleTitleLabel = UILabel()
    var summaryLabel = UILabel()
    var timePublishedLabel = UILabel()
    var authorsLabel = UILabel()
    var bannerImageView = UIImageView()

    // MARK: Inits

    override init(frame: CGRect) {
        super.init(frame: frame)

        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        bannerImageView.layer.cornerRadius = 5
        bannerImageView.sizeToFit()
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false

        sourceLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        sourceLabel.textColor = .label

        articleTitleLabel.font = UIFont.init(name: "AvenirNext-Bold", size: 18)
        articleTitleLabel.textColor = .label
        articleTitleLabel.numberOfLines = 2

        summaryLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        summaryLabel.textColor = .label

        timePublishedLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        timePublishedLabel.textColor = .label
         
        authorsLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        authorsLabel.textColor = .label

        let vStack = UIStackView(arrangedSubviews: [
            articleTitleLabel,
            bannerImageView,
            sourceLabel,
            timePublishedLabel
        ])

        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.alignment = .center
        vStack.axis = .vertical
        vStack.spacing = 4
        
        // DEBUG
        vStack.backgroundColor = .blue
        contentView.backgroundColor = .green
        
        bannerImageView.backgroundColor = .blue

        self.addSubview(vStack)

        NSLayoutConstraint.activate([
            // Content View
            //contentView.trailingAnchor.constraint(equalTo: super.leadingAnchor, constant: 0),

            // Vertical Stack
            //vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            //vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            vStack.widthAnchor.constraint(equalTo: super.widthAnchor, constant: 21),

            // Image View
            bannerImageView.heightAnchor.constraint(equalToConstant: 200),
            //bannerImageView.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            //bannerImageView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor)
            bannerImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("HAHAHA NOT HAPPENING")
    }

    func configure(item: NewsArticleItem) {
        sourceLabel.text = item.source
        articleTitleLabel.text = item.title
        summaryLabel.text = item.summary
        timePublishedLabel.text = item.timePublished
        bannerImageView.image = item.bannerImage
        authorsLabel.text = item.authors.toString()
    }

}
