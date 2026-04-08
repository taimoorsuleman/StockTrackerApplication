//
//  StockRowViewData.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation

/// Formats domain stock data into display ready values for one row
/// in the stocks list.
struct StockRowViewData: Identifiable, Equatable {

	// MARK: Properties

	let id: String
	let symbol: String
	let name: String
	let currentPriceText: String
	let priceChangeText: String
	let priceChangePercentageText: String
	let isPositiveChange: Bool
	let isNegativeChange: Bool
	let isUnchanged: Bool

	// MARK: Initialization

	init(stock: Stock) {
		id = stock.id
		symbol = stock.symbol
		name = stock.name
		currentPriceText = String(format: "$%.2f", stock.currentPrice)
		priceChangeText = String(
			format: "%@%.2f",
			stock.priceChange >= 0 ? "+" : "",
			stock.priceChange
		)
		priceChangePercentageText = String(
			format: "%@%.2f%%",
			stock.priceChangePercentage >= 0 ? "+" : "",
			stock.priceChangePercentage
		)
		isPositiveChange = stock.isPositiveChange
		isNegativeChange = stock.isNegativeChange
		isUnchanged = stock.isUnchanged
	}
}
