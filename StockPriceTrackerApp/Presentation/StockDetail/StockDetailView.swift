//
//  StockDetailView.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import SwiftUI

/// Displays the selected stock's live details using the same shared repository
/// observed by the list screen.
struct StockDetailView: View {

	// MARK: Properties

	@StateObject private var viewModel: StockDetailViewModel

	// MARK: Initialization

	init(viewModel: StockDetailViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	// MARK: View

	var body: some View {
		Group {
			if let stock = viewModel.stock {
				ScrollView {
					VStack(alignment: .leading, spacing: 20) {
						VStack(alignment: .leading, spacing: 8) {
							Text(stock.symbol)
								.font(.largeTitle)
								.fontWeight(.bold)

							Text(stock.name)
								.font(.title3)
								.foregroundStyle(.secondary)
						}

						VStack(alignment: .leading, spacing: 8) {
							Text(stock.currentPriceText)
								.font(.system(size: 34, weight: .bold))

							Text("\(stock.priceChangeText) (\(stock.priceChangePercentageText))")
								.font(.headline)
								.foregroundStyle(changeColor(for: stock))
						}

						VStack(alignment: .leading, spacing: 8) {
							Text("About")
								.font(.headline)

							Text(stock.description)
								.font(.body)
								.foregroundStyle(.secondary)
						}

						Spacer(minLength: 0)
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding()
				}
			} else {
				ContentUnavailableView(
					"Stock Not Found",
					systemImage: "exclamationmark.triangle",
					description: Text("The selected stock could not be loaded.")
				)
			}
		}
		.navigationTitle(viewModel.symbol)
		.navigationBarTitleDisplayMode(.inline)
	}

	// MARK: Private Helpers

	/// Keeps price movement styling consistent with the list screen.
	private func changeColor(for stock: StockDetailViewData) -> Color {
		if stock.isPositiveChange {
			return .green
		} else if stock.isNegativeChange {
			return .red
		} else {
			return .gray
		}
	}
}
