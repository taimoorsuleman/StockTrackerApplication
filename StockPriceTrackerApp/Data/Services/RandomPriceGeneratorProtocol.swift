//
//  RandomPriceGeneratorProtocol.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation

/// Defines the price generation behavior used by the simulated live feed.
protocol RandomPriceGeneratorProtocol {

	// MARK: Price Generation

	func nextPrice(from currentPrice: Double) -> Double
}

/// Generates random price movements to simulate live market updates.
/// The generated price is clamped to a minimum value so it never becomes invalid.
struct RandomPriceGenerator: RandomPriceGeneratorProtocol {

	// MARK: Properties

	private let minimumPrice: Double
	private let maximumPercentChange: Double

	// MARK: Initialization

	init(
		minimumPrice: Double = 1,
		maximumPercentChange: Double = 0.05
	) {
		self.minimumPrice = minimumPrice
		self.maximumPercentChange = maximumPercentChange
	}

	// MARK: Public Methods

	/// Applies a random percentage change within the configured range
	/// and prevents the result from dropping below the configured minimum.
	func nextPrice(from currentPrice: Double) -> Double {
		let percentageDelta = Double.random(in: -maximumPercentChange...maximumPercentChange)
		let updatedPrice = currentPrice * (1 + percentageDelta)
		return max(updatedPrice, minimumPrice)
	}
}
