//
//  MarketNewsViewController.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-15.
//

import Foundation
import UIKit
import Combine
import SwiftUI

class MarketNewsViewController: UIViewController {

    // MARK: - Properties

    typealias DataSource = UICollectionViewDiffableDataSource<NewsSection, FeedItem> // Section Identifier & type
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<NewsSection, FeedItem>

    lazy var dataSource = { configureDiffableDataSource() }()

    private var collectionView: UICollectionView!
    private var cancellable: Set<AnyCancellable> = []
    var client: HTTPClient = HTTPClient()

    @Published var initialLoad: MarketData?
    @Published var searchQuery: String = String()

    // MARK: - Creation

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationView()
        setupCollectionView()
        loadInitialNews()
        startObservers()
    }

    private func setupNavigationView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Market News 🗞"

        let filterButton = UIBarButtonItem(
            image: .init(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain, target: self,
            action: #selector(filterButtonAction)
        )

        self.navigationItem.rightBarButtonItem = filterButton
    }

    @objc private func filterButtonAction() {
        let hostingController = UIHostingController(rootView: FilterSearchView(client: client))
        hostingController.modalPresentationStyle = .automatic
        self.present(hostingController, animated: true)
    }

    private func startObservers() {
        $initialLoad
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .compactMap({ ($0?.feed) })
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print("Error: \(error)")
                }
            } receiveValue: { [weak self] feed in
                self?.reloadData()
            }.store(in: &cancellable)

        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { completion in
                #warning("TODO - Error catching")
            } receiveValue: { [weak self] searchQuery in

                // TODO: - load by tickers or topics to do that i need a symbol list
                #warning("Check this out again")

            }.store(in: &cancellable)

    }

    private func loadInitialNews() {
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
            self?.initialLoad = marketData
        }.store(in: &cancellable)
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
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 0)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.93),
            heightDimension: .estimated(400)
        )

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    // MARK: - Configure Data Source

    private func configureDiffableDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, itemIdentifier in

            if indexPath.item < 3 {} else {}

            return try? self?.configureCell(
                cellType: LargeNewsCollectionViewCell.self,
                collectionView: collectionView,
                indexPath: indexPath,
                newsArticle: (self?.configureNewsItem(item: itemIdentifier))!
            )
        }

        return dataSource
    }

    private func configureNewsItem(item: FeedItem) -> NewsArticleItem {
        let newsArticleItem = NewsArticleItem(
            bannerImage: item.bannerImage,
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            throw CellConfigureError.init(
                errorCode: CellConfigureError.ErrorCodes.unableToDequeueCell.rawValue,
                errorUserInfo: [
                    CellConfigureError.UserInfoKey.failureReason.rawValue: "Failed to dequeue cell \(cellType)"
                ])
        }

        cell.configure(item: newsArticle)
        

        return cell
    }

    private func reloadData() {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([.topStories, .additionalStories])

        guard let feed = initialLoad?.feed else { return }

        snapshot.appendItems(feed, toSection: .topStories)

        self.dataSource.apply(snapshot)
    }

    // MARK: - Get Request

    private func getRequest(
        function: String = "NEWS_SENTIMENT",
        tickers: String = "AAPL",
        topics: String = "technology",
        limit: String = "20"
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

// MARK: - UICollectionView Delegate
extension MarketNewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // open web view to url
    }
}
