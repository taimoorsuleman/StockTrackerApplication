//
//  Stock.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation

/// Represents one stock item displayed in the app, including its current
/// and previous price so change values can be derived consistently.
struct Stock: Identifiable, Equatable {

	// MARK: Properties

	let id: String
	let symbol: String
	let name: String
	let description: String
	let currentPrice: Double
	let previousPrice: Double

	// MARK: Initialization

	init(
		symbol: String,
		name: String,
		description: String,
		currentPrice: Double,
		previousPrice: Double? = nil
	) {
		self.id = symbol
		self.symbol = symbol
		self.name = name
		self.description = description
		self.currentPrice = currentPrice
		self.previousPrice = previousPrice ?? currentPrice
	}

	// MARK: Derived Values

	var priceChange: Double {
		currentPrice - previousPrice
	}

	var priceChangePercentage: Double {
		guard previousPrice != 0 else { return 0 }
		return (priceChange / previousPrice) * 100
	}

	var isPositiveChange: Bool {
		priceChange > 0
	}

	var isNegativeChange: Bool {
		priceChange < 0
	}

	var isUnchanged: Bool {
		priceChange == 0
	}

	// MARK: Price Updates

	/// Returns a new stock value with the updated price while preserving the
	/// previous current price for change and percentage calculations.
	func updatingPrice(to newPrice: Double) -> Stock {
		Stock(
			symbol: symbol,
			name: name,
			description: description,
			currentPrice: newPrice,
			previousPrice: currentPrice
		)
	}
}
