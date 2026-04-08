//
//  StockCatalogDataSourceProtocol.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation

/// Provides the static stock catalog used to seed the app with symbols,
/// names, descriptions, and starting prices.
protocol StockCatalogDataSourceProtocol {

	// MARK: Data Access

	func fetchStocks() -> [Stock]
	func fetchStock(symbol: String) -> Stock?
}

