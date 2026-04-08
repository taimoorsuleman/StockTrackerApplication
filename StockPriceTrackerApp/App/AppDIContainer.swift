//
//  AppDIContainer.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation

/// Centralizes dependency creation for the app and keeps one shared
/// stock repository instance so live updates stay synchronized across screens.
@MainActor
final class AppDIContainer {

	// MARK: Properties

	private let stockRepository: StockRepositoryProtocol

	// MARK: Initialization

	/// Builds the shared dependency graph for the application.
	/// The same repository instance is injected into both list and detail flows.
	init() {
		let stockCatalogDataSource = StockCatalogDataSource()
		let socketURL = URL(string: "wss://ws.postman-echo.com/raw")!

		let webSocketClient = URLSessionWebSocketClient(url: socketURL)
		let randomPriceGenerator = RandomPriceGenerator()

		let stockFeedService = StockFeedService(
			webSocketClient: webSocketClient,
			randomPriceGenerator: randomPriceGenerator
		)

		self.stockRepository = StockRepository(
			stockCatalogDataSource: stockCatalogDataSource,
			stockFeedService: stockFeedService
		)
	}

	// MARK: Factory Methods

	/// Creates the list screen ViewModel backed by the shared stock repository.
	func makeStocksListViewModel() -> StocksListViewModel {
		StocksListViewModel(stockRepository: stockRepository)
	}

	/// Creates a detail screen ViewModel for the selected symbol using the same
	/// shared repository observed by the list screen.
	func makeStockDetailViewModel(symbol: String) -> StockDetailViewModel {
		StockDetailViewModel(
			symbol: symbol,
			stockRepository: stockRepository
		)
	}
}
