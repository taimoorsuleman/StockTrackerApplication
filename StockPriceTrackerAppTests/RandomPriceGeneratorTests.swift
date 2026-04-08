//
//  RandomPriceGeneratorTests.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 08/04/2026.
//


import XCTest
@testable import StockPriceTrackerApp

final class RandomPriceGeneratorTests: XCTestCase {

	// MARK: Minimum Price

	/// Verifies that the generated price never drops below the configured minimum.
	func test_nextPrice_doesNotGoBelowMinimumPrice() {
		let generator = RandomPriceGenerator(
			minimumPrice: 1,
			maximumPercentChange: 0.10
		)

		for _ in 0..<1000 {
			let generatedPrice = generator.nextPrice(from: 0.5)
			XCTAssertGreaterThanOrEqual(generatedPrice, 1)
		}
	}

	// MARK: Range Validation

	/// Verifies that the generated price stays within the configured percentage range.
	func test_nextPrice_staysWithinExpectedPercentageRange() {
		let generator = RandomPriceGenerator(
			minimumPrice: 1,
			maximumPercentChange: 0.10
		)

		let currentPrice = 100.0
		let minimumExpectedPrice = 90.0
		let maximumExpectedPrice = 110.0

		for _ in 0..<1000 {
			let generatedPrice = generator.nextPrice(from: currentPrice)

			XCTAssertGreaterThanOrEqual(generatedPrice, minimumExpectedPrice)
			XCTAssertLessThanOrEqual(generatedPrice, maximumExpectedPrice)
		}
	}

	// MARK: Stability

	/// Verifies that the generator can produce valid prices repeatedly
	/// without returning invalid numeric values.
	func test_nextPrice_returnsFiniteValues() {
		let generator = RandomPriceGenerator(
			minimumPrice: 1,
			maximumPercentChange: 0.10
		)

		for _ in 0..<1000 {
			let generatedPrice = generator.nextPrice(from: 250)
			XCTAssertTrue(generatedPrice.isFinite)
		}
	}
}