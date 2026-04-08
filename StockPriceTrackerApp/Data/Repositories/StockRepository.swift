//
//  StockRepository.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation
import Combine

/// Shared source of truth for stock data, connection state, and inline feed errors.
/// Both the list and detail screens observe this repository so they stay in sync.
@MainActor
final class StockRepository: StockRepositoryProtocol {

	// MARK: Publishers

	var stocksPublisher: AnyPublisher<[Stock], Never> {
		$stocks.eraseToAnyPublisher()
	}

	var connectionStatePublisher: AnyPublisher<ConnectionState, Never> {
		$connectionState.eraseToAnyPublisher()
	}

	var errorMessagePublisher: AnyPublisher<String?, Never> {
		$errorMessage.eraseToAnyPublisher()
	}

	// MARK: Current State

	var currentStocks: [Stock] {
		stocks
	}

	var currentConnectionState: ConnectionState {
		connectionState
	}

	// MARK: Stored Properties

	@Published private var stocks: [Stock]
	@Published private var connectionState: ConnectionState = .disconnected
	@Published private var errorMessage: String?

	private let stockFeedService: StockFeedServiceProtocol

	// MARK: Initialization

	init(
		stockCatalogDataSource: StockCatalogDataSourceProtocol,
		stockFeedService: StockFeedServiceProtocol
	) {
		self.stocks = stockCatalogDataSource.fetchStocks()
		self.stockFeedService = stockFeedService

		bindFeedService()
	}

	// MARK: Public Methods

	func startFeed() {
		print("StockRepository: start feed requested")
		errorMessage = nil

		stockFeedService.start { [weak self] in
			self?.stocks ?? []
		}
	}

	func stopFeed() {
		print("StockRepository: stop feed requested")
		errorMessage = nil
		stockFeedService.stop()
	}

	/// Publishes only the selected stock so the detail screen can stay updated
	/// without depending on the full list state.
	func stockPublisher(for symbol: String) -> AnyPublisher<Stock?, Never> {
		$stocks
			.map { stocks in
				stocks.first { $0.symbol == symbol }
			}
			.eraseToAnyPublisher()
	}

	// MARK: Private Methods

	/// Binds feed level events to repository state that is observed by the UI layer.
	private func bindFeedService() {
		stockFeedService.onConnectionStateChanged = { [weak self] state in
			guard let self else { return }

			Task { @MainActor in
				self.connectionState = state

				if state == .connected {
					self.errorMessage = nil
				}
			}
		}

		stockFeedService.onPriceTickReceived = { [weak self] tick in
			guard let self else { return }

			Task { @MainActor in
				self.apply(priceTick: tick)
			}
		}

		stockFeedService.onErrorMessage = { [weak self] message in
			guard let self else { return }

			Task { @MainActor in
				self.errorMessage = message
			}
		}
	}

	/// Applies a new price while preserving the previous price
	/// so change and percentage calculations remain accurate.
	private func apply(priceTick: PriceTick) {
		guard let index = stocks.firstIndex(where: { $0.symbol == priceTick.symbol }) else {
			return
		}

		let currentStock = stocks[index]
		let updatedStock = currentStock.updatingPrice(to: priceTick.price)
		stocks[index] = updatedStock

		print("StockRepository: applied tick for \(priceTick.symbol)")
	}
}
