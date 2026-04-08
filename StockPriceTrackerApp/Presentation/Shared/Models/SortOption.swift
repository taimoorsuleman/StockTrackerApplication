//
//  SortOption.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation

/// Defines the supported sorting modes for the stocks table.
enum SortOption: String, CaseIterable, Identifiable {

	// MARK: Cases

	case stock = "Stock"
	case price = "Price"
	case priceChange = "Change"
	case priceChangePercentage = "Change %"

	// MARK: Identifiable

	var id: String { rawValue }
}
