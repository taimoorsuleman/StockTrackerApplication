//
//  StockCatalogDataSourceTests.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 08/04/2026.
//


import XCTest
@testable import StockPriceTrackerApp

final class StockCatalogDataSourceTests: XCTestCase {

	// MARK: Fetch Stocks

	/// Verifies that the catalog returns the expected number of stocks.
	func test_fetchStocks_returnsExpectedStockCount() {
		let dataSource = StockCatalogDataSource()

		let stocks = dataSource.fetchStocks()

		XCTAssertEqual(stocks.count, 25)
	}

	/// Verifies that the catalog contains known stock symbols used by the app.
	func test_fetchStocks_containsExpectedSymbols() {
		let dataSource = StockCatalogDataSource()

		let stocks = dataSource.fetchStocks()
		let symbols = stocks.map(\.symbol)

		XCTAssertTrue(symbols.contains("AAPL"))
		XCTAssertTrue(symbols.contains("NVDA"))
		XCTAssertTrue(symbols.contains("TSLA"))
		XCTAssertTrue(symbols.contains("AMZN"))
		XCTAssertTrue(symbols.contains("MSFT"))
	}

	// MARK: Fetch Single Stock

	/// Verifies that fetching by a valid symbol returns the correct stock.
	func test_fetchStock_withValidSymbol_returnsMatchingStock() {
		let dataSource = StockCatalogDataSource()

		let stock = dataSource.fetchStock(symbol: "AAPL")

		XCTAssertNotNil(stock)
		XCTAssertEqual(stock?.symbol, "AAPL")
		XCTAssertEqual(stock?.name, "Apple")
	}

	/// Verifies that fetching by an unknown symbol returns nil.
	func test_fetchStock_withInvalidSymbol_returnsNil() {
		let dataSource = StockCatalogDataSource()

		let stock = dataSource.fetchStock(symbol: "INVALID")

		XCTAssertNil(stock)
	}
}