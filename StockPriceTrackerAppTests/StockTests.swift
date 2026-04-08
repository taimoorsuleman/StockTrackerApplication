//
//  StockTests.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 08/04/2026.
//


import XCTest
@testable import StockPriceTrackerApp

final class StockTests: XCTestCase {

	// MARK: Price Change

	/// Verifies that price change is calculated as the difference
	/// between the current and previous price.
	func test_priceChange_returnsDifferenceBetweenCurrentAndPreviousPrice() {
		let stock = makeStock(
			currentPrice: 110,
			previousPrice: 100
		)

		XCTAssertEqual(stock.priceChange, 10)
	}

	/// Verifies that price change percentage is calculated correctly.
	func test_priceChangePercentage_returnsExpectedValue() {
		let stock = makeStock(
			currentPrice: 110,
			previousPrice: 100
		)

		XCTAssertEqual(stock.priceChangePercentage, 10)
	}

	// MARK: State Flags

	/// Verifies that a positive price difference is identified correctly.
	func test_isPositiveChange_returnsTrueForPositiveChange() {
		let stock = makeStock(
			currentPrice: 120,
			previousPrice: 100
		)

		XCTAssertTrue(stock.isPositiveChange)
		XCTAssertFalse(stock.isNegativeChange)
		XCTAssertFalse(stock.isUnchanged)
	}

	/// Verifies that a negative price difference is identified correctly.
	func test_isNegativeChange_returnsTrueForNegativeChange() {
		let stock = makeStock(
			currentPrice: 90,
			previousPrice: 100
		)

		XCTAssertTrue(stock.isNegativeChange)
		XCTAssertFalse(stock.isPositiveChange)
		XCTAssertFalse(stock.isUnchanged)
	}

	/// Verifies that equal prices are treated as unchanged.
	func test_isUnchanged_returnsTrueWhenPricesAreEqual() {
		let stock = makeStock(
			currentPrice: 100,
			previousPrice: 100
		)

		XCTAssertTrue(stock.isUnchanged)
		XCTAssertFalse(stock.isPositiveChange)
		XCTAssertFalse(stock.isNegativeChange)
	}

	// MARK: Price Update

	/// Verifies that updating the price preserves the old current price
	/// as the new previous price.
	func test_updatingPrice_setsPreviousPriceToOldCurrentPrice() {
		let stock = makeStock(
			currentPrice: 150,
			previousPrice: 140
		)

		let updatedStock = stock.updatingPrice(to: 165)

		XCTAssertEqual(updatedStock.symbol, stock.symbol)
		XCTAssertEqual(updatedStock.name, stock.name)
		XCTAssertEqual(updatedStock.description, stock.description)
		XCTAssertEqual(updatedStock.currentPrice, 165)
		XCTAssertEqual(updatedStock.previousPrice, 150)
	}

	/// Verifies that percentage calculation safely returns zero
	/// when the previous price is zero.
	func test_priceChangePercentage_returnsZeroWhenPreviousPriceIsZero() {
		let stock = makeStock(
			currentPrice: 100,
			previousPrice: 0
		)

		XCTAssertEqual(stock.priceChangePercentage, 0)
	}
}

// MARK: Test Helpers

private extension StockTests {
	func makeStock(
		currentPrice: Double,
		previousPrice: Double
	) -> Stock {
		Stock(
			symbol: "AAPL",
			name: "Apple",
			description: "Apple description",
			currentPrice: currentPrice,
			previousPrice: previousPrice
		)
	}
}