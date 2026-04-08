//
//  WebSocketClient.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation

/// Defines the minimal socket interface needed by the app's feed layer.
/// This abstraction keeps the networking implementation replaceable and easy to test.
protocol WebSocketClient: AnyObject {

	// MARK: Callbacks

	var onConnected: (() -> Void)? { get set }
	var onDisconnected: (() -> Void)? { get set }
	var onTextReceived: ((String) -> Void)? { get set }
	var onError: ((Error) -> Void)? { get set }

	// MARK: Actions

	func connect()
	func disconnect()
	func send(text: String)
}
