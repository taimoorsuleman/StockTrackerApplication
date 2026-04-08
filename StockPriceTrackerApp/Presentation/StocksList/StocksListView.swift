//
//  StocksListView.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import SwiftUI
import Combine

/// Renders the main stocks screen and maps user interactions such as sorting
/// and feed control into ViewModel actions.
struct StocksListView: View {

	// MARK: Properties

	@StateObject private var viewModel: StocksListViewModel
	private let makeStockDetailViewModel: (String) -> StockDetailViewModel

	// MARK: Initialization

	init(
		viewModel: StocksListViewModel,
		makeStockDetailViewModel: @escaping (String) -> StockDetailViewModel
	) {
		_viewModel = StateObject(wrappedValue: viewModel)
		self.makeStockDetailViewModel = makeStockDetailViewModel
	}

	// MARK: View

	var body: some View {
		GeometryReader { geometry in
			/// Uses the actual content width so the header and row columns remain aligned
			/// inside the padded page layout on all device sizes.
			let contentWidth = geometry.size.width - 32
			let layout = StockTableLayout.make(for: contentWidth)

			ScrollView {
				VStack(spacing: 16) {
					controlsSection
					tableHeader(layout: layout)
					stocksTable(layout: layout)
				}
				.padding()
			}
			.background(Color(.systemGroupedBackground))
		}
		.navigationTitle("Stocks")
	}

	// MARK: Private Views

	/// The header reuses the same shared layout as the data rows so columns stay aligned.
	private func tableHeader(layout: StockTableLayout) -> some View {
		HStack(spacing: layout.spacing) {
			StockHeaderSortButton(
				title: "Stock",
				isSelected: viewModel.selectedSortOption == .stock,
				isAscending: viewModel.isAscending,
				action: { viewModel.sort(by: .stock) },
				alignment: .leading
			)
			.frame(width: layout.stockWidth, alignment: .leading)

			StockHeaderSortButton(
				title: "Price",
				isSelected: viewModel.selectedSortOption == .price,
				isAscending: viewModel.isAscending,
				action: { viewModel.sort(by: .price) },
				alignment: .trailing
			)
			.frame(width: layout.priceWidth, alignment: .trailing)

			StockHeaderSortButton(
				title: "Change",
				isSelected: viewModel.selectedSortOption == .priceChange,
				isAscending: viewModel.isAscending,
				action: { viewModel.sort(by: .priceChange) },
				alignment: .trailing
			)
			.frame(width: layout.changeWidth, alignment: .trailing)

			StockHeaderSortButton(
				title: "Change %",
				isSelected: viewModel.selectedSortOption == .priceChangePercentage,
				isAscending: viewModel.isAscending,
				action: { viewModel.sort(by: .priceChangePercentage) },
				alignment: .trailing
			)
			.frame(width: layout.percentageWidth, alignment: .trailing)
		}
		.padding(.horizontal, layout.horizontalPadding)
	}

	private var controlsSection: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack(spacing: 12) {
				HStack(spacing: 8) {
					Circle()
						.fill(connectionColor)
						.frame(width: 10, height: 10)

					Text(connectionStatusText)
						.font(.subheadline)
						.foregroundStyle(.secondary)
				}

				Spacer()

				Button(buttonTitle) {
					handleFeedButtonTap()
				}
				.buttonStyle(.borderedProminent)
			}

			if let bannerMessage = viewModel.bannerMessage {
				Text(bannerMessage)
					.font(.caption)
					.foregroundStyle(.red)
			}
		}
		.padding()
		.background(Color(.secondarySystemGroupedBackground))
		.clipShape(RoundedRectangle(cornerRadius: 12))
	}

	private func stocksTable(layout: StockTableLayout) -> some View {
		LazyVStack(spacing: 0) {
			ForEach(viewModel.stocks) { stock in
				NavigationLink {
					StockDetailView(
						viewModel: makeStockDetailViewModel(stock.symbol)
					)
				} label: {
					VStack(spacing: 0) {
						StockTableRowView(
							stock: stock,
							layout: layout
						)

						Divider()
					}
				}
				.buttonStyle(.plain)
			}
		}
		.background(Color(.systemBackground))
		.clipShape(RoundedRectangle(cornerRadius: 12))
	}

	// MARK: Private Computed Properties

	private var buttonTitle: String {
		switch viewModel.connectionState {
		case .connected, .connecting:
			return "Stop Feed"
		case .disconnected:
			return "Start Feed"
		}
	}

	private var connectionStatusText: String {
		switch viewModel.connectionState {
		case .connected:
			return "Connected"
		case .connecting:
			return "Connecting..."
		case .disconnected:
			return "Disconnected"
		}
	}

	private var connectionColor: Color {
		switch viewModel.connectionState {
		case .connected:
			return .green
		case .connecting:
			return .orange
		case .disconnected:
			return .red
		}
	}

	// MARK: Private Actions

	/// Uses the current connection state to decide whether the live feed should start or stop.
	private func handleFeedButtonTap() {
		switch viewModel.connectionState {
		case .connected, .connecting:
			viewModel.stopFeed()
		case .disconnected:
			viewModel.startFeed()
		}
	}
}
