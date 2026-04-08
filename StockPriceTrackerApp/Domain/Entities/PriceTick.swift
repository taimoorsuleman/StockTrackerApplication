//
//  PriceTick.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation

/// Represents one live price update exchanged through the WebSocket echo flow.
struct PriceTick: Codable, Equatable {
	let symbol: String
	let price: Double
	let timestamp: Date
}
