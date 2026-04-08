//
//  StockTableLayout.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 08/04/2026.
//

import CoreGraphics

/// Defines proportional column sizing for the stock table based on the
/// available screen width so headers and rows stay aligned on all devices.
struct StockTableLayout {

	// MARK: Properties

	let stockWidth: CGFloat
	let priceWidth: CGFloat
	let changeWidth: CGFloat
	let percentageWidth: CGFloat
	let spacing: CGFloat
	let horizontalPadding: CGFloat

	// MARK: Factory

	/// Builds a shared layout configuration from the available content width.
	/// Both the header and each row use the same values to keep columns aligned.
	static func make(for totalWidth: CGFloat) -> StockTableLayout {
		let horizontalPadding: CGFloat = 12
		let spacing: CGFloat = 10
		let totalSpacing = spacing * 3
		let available = totalWidth - (horizontalPadding * 2) - totalSpacing

		let stockWidth = available * 0.22
		let priceWidth = available * 0.28
		let changeWidth = available * 0.23
		let percentageWidth = available * 0.27

		return StockTableLayout(
			stockWidth: stockWidth,
			priceWidth: priceWidth,
			changeWidth: changeWidth,
			percentageWidth: percentageWidth,
			spacing: spacing,
			horizontalPadding: horizontalPadding
		)
	}
}
