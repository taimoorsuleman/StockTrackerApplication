//
//  StockTableRowView.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 03/04/2026.
//

import SwiftUI

/// Displays one stock row using the same shared table layout as the header
/// so all columns remain visually aligned across device sizes.
struct StockTableRowView: View {

	// MARK: Properties

	let stock: StockRowViewData
	let layout: StockTableLayout

	// MARK: View

	var body: some View {
		HStack(spacing: layout.spacing) {
			Text(stock.symbol)
				.font(.headline)
				.lineLimit(1)
				.minimumScaleFactor(0.75)
				.frame(width: layout.stockWidth, alignment: .leading)

			Text(stock.currentPriceText)
				.font(.subheadline)
				.monospacedDigit()
				.lineLimit(1)
				.minimumScaleFactor(0.75)
				.frame(width: layout.priceWidth, alignment: .trailing)

			Text(stock.priceChangeText)
				.font(.subheadline)
				.monospacedDigit()
				.foregroundStyle(changeColor)
				.lineLimit(1)
				.minimumScaleFactor(0.75)
				.frame(width: layout.changeWidth, alignment: .trailing)

			Text(stock.priceChangePercentageText)
				.font(.subheadline)
				.monospacedDigit()
				.foregroundStyle(changeColor)
				.lineLimit(1)
				.minimumScaleFactor(0.75)
				.frame(width: layout.percentageWidth, alignment: .trailing)
		}
		.padding(.horizontal, layout.horizontalPadding)
		.padding(.vertical, 12)
		.contentShape(Rectangle())
	}

	// MARK: Private Helpers

	/// Keeps price movement styling consistent across all numeric change values.
	private var changeColor: Color {
		if stock.isPositiveChange {
			return .green
		} else if stock.isNegativeChange {
			return .red
		} else {
			return .gray
		}
	}
}
