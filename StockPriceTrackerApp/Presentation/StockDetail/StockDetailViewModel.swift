//
//  StockDetailViewModel.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation
import Combine

/// Observes a single stock from the shared repository so the detail screen
/// stays synchronized with the live updates shown in the list screen.
@MainActor
final class StockDetailViewModel: ObservableObject {

	// MARK: Published Properties

	@Published private(set) var stock: StockDetailViewData?

	// MARK: Properties

	let symbol: String

	private let stockRepository: StockRepositoryProtocol
	private var cancellables = Set<AnyCancellable>()

	// MARK: Initialization

	init(
		symbol: String,
		stockRepository: StockRepositoryProtocol
	) {
		self.symbol = symbol
		self.stockRepository = stockRepository
		bind()
	}

	// MARK: Private Methods

	/// Observes the selected symbol only, keeping the detail screen updated
	/// without depending on the full list state.
	private func bind() {
		stockRepository.stockPublisher(for: symbol)
			.sink { [weak self] stock in
				guard let self else { return }
				self.stock = stock.map(StockDetailViewData.init)
			}
			.store(in: &cancellables)
	}
}
