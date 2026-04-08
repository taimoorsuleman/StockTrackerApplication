//
//  StocksListViewModel.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation
import Combine

/// Maps repository updates into list friendly UI state and manages sorting,
/// feed controls, and inline status messaging for the stocks screen.
@MainActor
final class StocksListViewModel: ObservableObject {

	// MARK: Published Properties

	@Published private(set) var stocks: [StockRowViewData] = []
	@Published private(set) var connectionState: ConnectionState = .disconnected
	@Published private(set) var selectedSortOption: SortOption = .price
	@Published private(set) var isAscending: Bool = false
	@Published private(set) var bannerMessage: String?

	// MARK: Properties

	private let stockRepository: StockRepositoryProtocol
	private var cancellables = Set<AnyCancellable>()
	private var allStocks: [Stock] = []

	// MARK: Initialization

	init(stockRepository: StockRepositoryProtocol) {
		self.stockRepository = stockRepository
		bind()
	}

	// MARK: Public Actions

	func startFeed() {
		print("StocksListViewModel: start feed tapped")
		stockRepository.startFeed()
	}

	func stopFeed() {
		print("StocksListViewModel: stop feed tapped")
		stockRepository.stopFeed()
	}

	/// Tapping the active column toggles sort direction.
	/// Tapping a new column switches the active sort and resets its direction.
	func sort(by option: SortOption) {
		if selectedSortOption == option {
			isAscending.toggle()
		} else {
			selectedSortOption = option
			isAscending = option == .stock
		}

		applySorting()
	}

	// MARK: Private Methods

	/// Binds repository publishers to UI state consumed by the stocks list screen.
	private func bind() {
		stockRepository.stocksPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] stocks in
				guard let self else { return }
				self.allStocks = stocks
				self.applySorting()
			}
			.store(in: &cancellables)

		stockRepository.connectionStatePublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] state in
				guard let self else { return }
				self.connectionState = state

				if state == .connected {
					self.bannerMessage = nil
				}
			}
			.store(in: &cancellables)

		stockRepository.errorMessagePublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] message in
				guard let self else { return }
				self.bannerMessage = message
			}
			.store(in: &cancellables)
	}

	/// Applies the current sorting mode to the latest stock collection
	/// before mapping domain models into row view data.
	private func applySorting() {
		let sortedStocks: [Stock]

		switch selectedSortOption {
		case .stock:
			sortedStocks = allStocks.sorted { compare($0.symbol, $1.symbol) }

		case .price:
			sortedStocks = allStocks.sorted { compare($0.currentPrice, $1.currentPrice) }

		case .priceChange:
			sortedStocks = allStocks.sorted { compare($0.priceChange, $1.priceChange) }

		case .priceChangePercentage:
			sortedStocks = allStocks.sorted { compare($0.priceChangePercentage, $1.priceChangePercentage) }
		}

		stocks = sortedStocks.map(StockRowViewData.init)
	}

	/// Applies either ascending or descending comparison depending on
	/// the currently selected sorting direction.
	private func compare<T: Comparable>(_ lhs: T, _ rhs: T) -> Bool {
		isAscending ? lhs < rhs : lhs > rhs
	}
}
