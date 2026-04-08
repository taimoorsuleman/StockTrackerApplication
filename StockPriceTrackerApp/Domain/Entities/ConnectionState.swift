//
//  ConnectionState.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation

/// Represents the current lifecycle state of the live price feed connection.
enum ConnectionState: Equatable {

	case disconnected
	case connecting
	case connected

	/// User facing text shown in the feed status section.
	var title: String {
		switch self {
		case .disconnected:
			return "Disconnected"
		case .connecting:
			return "Connecting..."
		case .connected:
			return "Connected"
		}
	}
}
