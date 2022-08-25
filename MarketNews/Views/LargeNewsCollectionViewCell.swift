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

        let seperator = UIView(frame: .zero)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = .blue

        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        bannerImageView.layer.cornerRadius = 5
        bannerImageView.sizeToFit()
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false

        sourceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        sourceLabel.textColor = .black

        articleTitleLabel.font = UIFont.init(name: "Helvetica-Bold", size: 25)
        articleTitleLabel.textColor = .label
        articleTitleLabel.numberOfLines = 2
        articleTitleLabel.textAlignment = .center

        summaryLabel.font = UIFont.init(name: "Helvetica", size: 15)
        summaryLabel.textColor = .label
        summaryLabel.numberOfLines = 3
        summaryLabel.lineBreakMode = .byTruncatingTail

        timePublishedLabel.font = UIFont.boldSystemFont(ofSize: 12)
        timePublishedLabel.textColor = .systemGray

        authorsLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        authorsLabel.textColor = .label

        let detailsVStack = UIStackView(arrangedSubviews: [
            sourceLabel,
            summaryLabel,
            timePublishedLabel
        ])

        detailsVStack.axis = .vertical
        detailsVStack.alignment = .leading
        detailsVStack.spacing = 4
        detailsVStack.translatesAutoresizingMaskIntoConstraints = false

        let vStack = UIStackView(arrangedSubviews: [
            articleTitleLabel,
            bannerImageView,
            detailsVStack,
            seperator
        ])

        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.alignment = .center
        vStack.axis = .vertical
        vStack.spacing = 4

        self.addSubview(vStack)

        NSLayoutConstraint.activate([
            seperator.heightAnchor.constraint(equalToConstant: 1),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            vStack.widthAnchor.constraint(equalTo: super.widthAnchor, constant: 21),

            bannerImageView.heightAnchor.constraint(equalToConstant: 200),
            bannerImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            detailsVStack.leadingAnchor.constraint(equalTo: vStack.leadingAnchor, constant: 15)
        ])

        vStack.setCustomSpacing(5, after: seperator)
        
        print(vStack.subviews.count)
    }

    required init?(coder: NSCoder) {
        fatalError("HAHAHA NOT HAPPENING")
    }

    func configure(item: NewsArticleItem) {
        sourceLabel.text = item.source
        articleTitleLabel.text = item.title
        summaryLabel.text = item.summary
        timePublishedLabel.text = item.timePublished.customDate()
        authorsLabel.text = item.authors.toString()

        if item.bannerImage == "" {
            bannerImageView.image = .placeHolderImage
        } else {
            bannerImageView.downloaded(from: item.bannerImage)
        }
    }

}
