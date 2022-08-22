//
//  MarketNewsViewController.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-15.
//

import Foundation
import UIKit
import Combine

class MarketNewsViewController: UIViewController {

    private var collectionView: UICollectionView!
    private var cancellable: Set<AnyCancellable> = []
    lazy var dataSource = { configureDiffableDataSource() }()
    typealias DataSource = UICollectionViewDiffableDataSource<NewsSection, FeedItem> // Section Identifier & type
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<NewsSection, FeedItem>

    var client: HTTPClient = HTTPClient()
    @Published var marketData: MarketData? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationView()
        setupCollectionView()
        networkCall()
        startObservers()
    }

    private func startObservers() {
        $marketData
            .receive(on: RunLoop.main)
            .compactMap({ ($0?.feed) })
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(error)
                }
            } receiveValue: { [weak self] feed in
                print("TESTING Feed \(feed.count)")
                self?.reloadData(feed: feed, section: .topStories)
            }.store(in: &cancellable)

    }

    private func networkCall() {
        client.publisher(
            for: getRequest(),
            response: MarketData.self
        ).sink { completion in
            switch completion {
            case .finished:
                break
            case let .failure(error):
                print(error)
            }
        } receiveValue: { [weak self] marketData in
            print("done")
            self?.marketData = marketData
        }.store(in: &cancellable)

    }
    private func setupNavigationView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "🗞News"
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createCompositionalLayout()
        )

        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .tertiarySystemBackground

        self.view.addSubview(collectionView)

        collectionView.register(LargeNewsCollectionViewCell.self, forCellWithReuseIdentifier: LargeNewsCollectionViewCell.reuseIdentifier)

        collectionView.dataSource = self.dataSource

        guard let feed = marketData?.feed else { return }

        self.reloadData(feed: feed, section: .topStories)
    }

    // MARK: - Configure Layouts

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { fatalError() }

            return self.configureTopStoriesLayout()
        }

        return layout
    }
    
    private func configureTopStoriesLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    private func configureDiffableDataSource() -> DataSource {
        let datasource = DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                if indexPath.item < 3 {} else {}

                return try? self?.configureCell(
                    cellType: LargeNewsCollectionViewCell.self,
                    collectionView: collectionView,
                    indexPath: indexPath,
                    newsArticle: (self?.configureNewsItem(item: itemIdentifier))!
                )
        })

        return dataSource
    }

    private func configureNewsItem(item: FeedItem) -> NewsArticleItem {
        print("returning news item")
        let result = item.bannerImage.stringToUIImage()
        var bannerImage = UIImage()

        switch result {
        case .success(let image):
            bannerImage = image
        case let .failure(error):
            print(error)
            bannerImage = .placeHolderImage
        }

        let newsArticleItem = NewsArticleItem(
            bannerImage: bannerImage,
            source: item.source,
            title: item.title,
            summary: item.summary,
            timePublished: item.timePublished,
            authors: item.authors
        )

        return newsArticleItem
    }

    private func configureCell<T: SelfConfiguringCell>(
        cellType: T.Type,
        collectionView: UICollectionView,
        indexPath: IndexPath,
        newsArticle: NewsArticleItem
    ) throws -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            throw CellConfigureError.init(
                errorCode: CellConfigureError.ErrorCodes.unableToDequeueCell.rawValue,
                errorUserInfo: [
                    CellConfigureError.UserInfoKey.failureReason.rawValue: "Failed to dequeue cell \(cellType)"
                ])
        }

        cell.configure(item: newsArticle)

        return cell
    }

    #warning("ISSUE starts here")
    private func reloadData(feed: [FeedItem], section: NewsSection = .topStories) {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([NewsSection.topStories, NewsSection.additionalStories])
        snapshot.appendItems(feed, toSection: section)
        self.dataSource.apply(snapshot)
    }

    // MARK: - Get Request

    private func getRequest(
        function: String = "NEWS_SENTIMENT", tickers: String = "AAPL",
        topics: String = "technology", limit: String = "20"
    ) -> Request<EmptyRequest> {
        Request(
            basePathURL: "https://www.alphavantage.co/query",
            httpMethod: .get,
            queryParams: [
                "function" : function,
                "tickers" : tickers,
                "topics" : topics,
                "limit" : limit,
                "apikey" : client.getApiKey
            ],
            body: nil
        )
    }
}

extension MarketNewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // open web view to url
    }
}
