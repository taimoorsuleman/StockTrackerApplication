//
//  StockFeedServiceProtocol.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 02/04/2026.
//

import Foundation

/// Defines the feed layer contract used by the repository.
/// It publishes connection changes, echoed price ticks, and non blocking error messages.
protocol StockFeedServiceProtocol: AnyObject {

	// MARK: Callbacks

	var onConnectionStateChanged: ((ConnectionState) -> Void)? { get set }
	var onPriceTickReceived: ((PriceTick) -> Void)? { get set }
	var onErrorMessage: ((String?) -> Void)? { get set }

	// MARK: Feed Control

	func start(with stocksProvider: @escaping () -> [Stock])
	func stop()
}

/// Generates simulated stock ticks, sends them through the WebSocket echo service,
/// and forwards echoed ticks back to the repository layer.
final class StockFeedService: StockFeedServiceProtocol {

	// MARK: Callbacks

	var onConnectionStateChanged: ((ConnectionState) -> Void)?
	var onPriceTickReceived: ((PriceTick) -> Void)?
	var onErrorMessage: ((String?) -> Void)?

	// MARK: Properties

	private let webSocketClient: WebSocketClient
	private let randomPriceGenerator: RandomPriceGeneratorProtocol
	private let encoder: JSONEncoder
	private let decoder: JSONDecoder

	private var timer: Timer?
	private var stocksProvider: (() -> [Stock])?
	private var isManuallyStopped = false

	// MARK: Initialization

	init(
		webSocketClient: WebSocketClient,
		randomPriceGenerator: RandomPriceGeneratorProtocol,
		encoder: JSONEncoder = JSONEncoder(),
		decoder: JSONDecoder = JSONDecoder()
	) {
		self.webSocketClient = webSocketClient
		self.randomPriceGenerator = randomPriceGenerator
		self.encoder = encoder
		self.decoder = decoder

		self.encoder.dateEncodingStrategy = .iso8601
		self.decoder.dateDecodingStrategy = .iso8601

		bindWebSocket()
	}

	// MARK: Public Methods

	/// Starts the feed using the shared stocks provider.
	/// The timer begins only after the socket reports a connected state.
	func start(with stocksProvider: @escaping () -> [Stock]) {
		guard timer == nil else {
			print("StockFeedService: start ignored because feed is already active")
			return
		}

		print("StockFeedService: start requested")
		isManuallyStopped = false
		self.stocksProvider = stocksProvider
		onErrorMessage?(nil)
		onConnectionStateChanged?(.connecting)
		webSocketClient.connect()
	}

	/// Stops tick generation and closes the socket connection.
	/// Manual stops also clear any existing inline error message.
	func stop() {
		print("StockFeedService: stop requested")
		isManuallyStopped = true
		timer?.invalidate()
		timer = nil
		webSocketClient.disconnect()
		onErrorMessage?(nil)
		onConnectionStateChanged?(.disconnected)
	}

	// MARK: Private Methods

	/// Binds low level socket events to app level callbacks used by the repository.
	private func bindWebSocket() {
		webSocketClient.onConnected = { [weak self] in
			guard let self else { return }
			print("StockFeedService: WebSocket connected")
			self.onErrorMessage?(nil)
			self.onConnectionStateChanged?(.connected)
			self.startTimer()
		}

		webSocketClient.onDisconnected = { [weak self] in
			guard let self else { return }
			print("StockFeedService: WebSocket disconnected")
			self.timer?.invalidate()
			self.timer = nil
			self.onConnectionStateChanged?(.disconnected)

			if !self.isManuallyStopped {
				self.onErrorMessage?("Live updates are temporarily unavailable.")
			}
		}

		webSocketClient.onTextReceived = { [weak self] text in
			guard let self else { return }

			do {
				let data = Data(text.utf8)
				let tick = try self.decoder.decode(PriceTick.self, from: data)
				print("StockFeedService: received echoed tick for \(tick.symbol) at \(tick.price)")
				self.onPriceTickReceived?(tick)
			} catch {
				/// A single malformed echoed message should not stop the full feed.
				print("StockFeedService: failed to decode echoed tick. Error: \(error.localizedDescription)")
			}
		}

		webSocketClient.onError = { [weak self] error in
			guard let self else { return }
			print("StockFeedService: WebSocket error: \(error.localizedDescription)")
			self.timer?.invalidate()
			self.timer = nil
			self.onConnectionStateChanged?(.disconnected)

			if !self.isManuallyStopped {
				self.onErrorMessage?("Unable to connect to the live price feed. Please try again.")
			}
		}
	}

	/// Starts a repeating timer that generates one simulated tick per interval.
	private func startTimer() {
		timer?.invalidate()

		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
			self?.sendRandomTick()
		}
	}

	/// The assessment uses an echo service instead of a real market provider.
	/// Each generated tick is sent out, then consumed again from the echoed response.
	private func sendRandomTick() {
		guard let stocksProvider else {
			print("StockFeedService: stocks provider is missing")
			return
		}

		let stocks = stocksProvider()
		guard !stocks.isEmpty else {
			print("StockFeedService: no stocks available to generate a tick")
			return
		}

		let randomIndex = Int.random(in: 0..<stocks.count)
		let stock = stocks[randomIndex]
		let nextPrice = randomPriceGenerator.nextPrice(from: stock.currentPrice)

		let tick = PriceTick(
			symbol: stock.symbol,
			price: nextPrice,
			timestamp: Date()
		)

		do {
			let data = try encoder.encode(tick)
			let text = String(decoding: data, as: UTF8.self)
			print("StockFeedService: sending tick for \(tick.symbol) at \(tick.price)")
			webSocketClient.send(text: text)
		} catch {
			print("StockFeedService: failed to encode tick. Error: \(error.localizedDescription)")
			timer?.invalidate()
			timer = nil
			onConnectionStateChanged?(.disconnected)
			onErrorMessage?("Unable to send live price updates right now.")
		}
	}

	deinit {
		timer?.invalidate()
	}
}
