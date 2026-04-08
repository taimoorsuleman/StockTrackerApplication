//
//  StockPriceTrackerApp.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import SwiftUI

@main
struct StockPriceTrackerApp: App {

	// MARK: Properties

	/// The app level dependency container used to build shared objects
	/// and screen specific ViewModels.
	private let container = AppDIContainer()

	// MARK: Scene

	var body: some Scene {
		WindowGroup {
			NavigationStack {
				StocksListView(
					viewModel: container.makeStocksListViewModel(),
					makeStockDetailViewModel: container.makeStockDetailViewModel
				)
			}
		}
	}
}
