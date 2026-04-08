//
//  StockRepositoryProtocol.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation
import Combine

/// Defines the shared stock data interface used by the presentation layer.
/// It exposes live stock updates, connection state, and feed related error messaging.
protocol StockRepositoryProtocol: AnyObject {

	// MARK: Publishers

	var stocksPublisher: AnyPublisher<[Stock], Never> { get }
	var connectionStatePublisher: AnyPublisher<ConnectionState, Never> { get }
	var errorMessagePublisher: AnyPublisher<String?, Never> { get }

	// MARK: Current State

	var currentStocks: [Stock] { get }
	var currentConnectionState: ConnectionState { get }

	// MARK: Feed Control

	func startFeed()
	func stopFeed()

	// MARK: Stock Access

	func stockPublisher(for symbol: String) -> AnyPublisher<Stock?, Never>
}
