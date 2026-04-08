//
//  URLSessionWebSocketClient.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation

/// Wraps `URLSessionWebSocketTask` behind the app's socket abstraction
/// and translates low level socket events into simple callbacks.
final class URLSessionWebSocketClient: WebSocketClient {

	// MARK: Callbacks

	var onConnected: (() -> Void)?
	var onDisconnected: (() -> Void)?
	var onTextReceived: ((String) -> Void)?
	var onError: ((Error) -> Void)?

	// MARK: Properties

	private let url: URL
	private let session: URLSession
	private var webSocketTask: URLSessionWebSocketTask?
	private var isConnected = false

	// MARK: Initialization

	init(
		url: URL,
		session: URLSession = .shared
	) {
		self.url = url
		self.session = session
	}

	// MARK: Public Methods

	/// Starts the socket handshake and begins listening for incoming messages.
	/// The connected callback is delayed slightly so the app does not try to send
	/// a message before the socket is ready.
	func connect() {
		guard webSocketTask == nil else { return }

		let task = session.webSocketTask(with: url)
		webSocketTask = task
		task.resume()

		listen()

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
			guard let self, self.webSocketTask != nil, !self.isConnected else { return }

			self.isConnected = true
			self.onConnected?()
		}
	}

	/// Closes the socket connection and resets the current task.
	func disconnect() {
		isConnected = false
		webSocketTask?.cancel(with: .goingAway, reason: nil)
		webSocketTask = nil
		onDisconnected?()
	}

	/// Sends a text payload through the active socket connection.
	func send(text: String) {
		guard isConnected, let webSocketTask else { return }

		webSocketTask.send(.string(text)) { [weak self] error in
			if let error {
				self?.onError?(error)
			}
		}
	}

	// MARK: Private Methods

	/// Continues listening recursively for as long as the socket task exists.
	private func listen() {
		guard let webSocketTask else { return }

		webSocketTask.receive { [weak self] result in
			guard let self else { return }

			switch result {
			case .success(let message):
				self.handle(message)

				if self.webSocketTask != nil {
					self.listen()
				}

			case .failure(let error):
				self.onError?(error)
				self.disconnect()
			}
		}
	}

	/// Normalizes both text and binary socket messages into text so the
	/// higher layers can decode one consistent format.
	private func handle(_ message: URLSessionWebSocketTask.Message) {
		switch message {
		case .string(let text):
			onTextReceived?(text)

		case .data(let data):
			if let text = String(data: data, encoding: .utf8) {
				onTextReceived?(text)
			}

		@unknown default:
			break
		}
	}
}
