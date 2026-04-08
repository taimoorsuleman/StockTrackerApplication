//
//  StockCatalogDataSource.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 08/04/2026.
//


/// Supplies the app's built in stock catalog used for initial list and detail data.
struct StockCatalogDataSource: StockCatalogDataSourceProtocol {

	// MARK: Public Methods

	func fetchStocks() -> [Stock] {
		Self.catalog
	}

	func fetchStock(symbol: String) -> Stock? {
		Self.catalog.first { $0.symbol == symbol }
	}

	// MARK: Private Catalog

	/// Kept as a shared static collection so the catalog is defined in one place
	/// and reused consistently across list and detail requests.
	private static let catalog: [Stock] = [
		Stock(
			symbol: "AAPL",
			name: "Apple",
			description: "Apple designs consumer electronics, software, and services.",
			currentPrice: 172.34
		),
		Stock(
			symbol: "GOOG",
			name: "Alphabet",
			description: "Alphabet is the parent company of Google and several technology businesses.",
			currentPrice: 148.62
		),
		Stock(
			symbol: "TSLA",
			name: "Tesla",
			description: "Tesla builds electric vehicles, battery systems, and energy products.",
			currentPrice: 181.55
		),
		Stock(
			symbol: "AMZN",
			name: "Amazon",
			description: "Amazon operates ecommerce, cloud computing, and digital media businesses.",
			currentPrice: 176.91
		),
		Stock(
			symbol: "MSFT",
			name: "Microsoft",
			description: "Microsoft develops software, cloud platforms, devices, and AI solutions.",
			currentPrice: 415.27
		),
		Stock(
			symbol: "NVDA",
			name: "NVIDIA",
			description: "NVIDIA designs graphics processors, AI chips, and high performance computing solutions.",
			currentPrice: 903.14
		),
		Stock(
			symbol: "META",
			name: "Meta",
			description: "Meta builds social platforms, messaging products, and virtual reality technologies.",
			currentPrice: 498.43
		),
		Stock(
			symbol: "NFLX",
			name: "Netflix",
			description: "Netflix provides streaming entertainment and original digital content.",
			currentPrice: 621.50
		),
		Stock(
			symbol: "AMD",
			name: "AMD",
			description: "AMD develops processors and graphics technologies for computing platforms.",
			currentPrice: 167.88
		),
		Stock(
			symbol: "INTC",
			name: "Intel",
			description: "Intel produces semiconductor chips and computing infrastructure products.",
			currentPrice: 42.76
		),
		Stock(
			symbol: "ORCL",
			name: "Oracle",
			description: "Oracle provides enterprise software, databases, and cloud services.",
			currentPrice: 126.35
		),
		Stock(
			symbol: "CRM",
			name: "Salesforce",
			description: "Salesforce offers customer relationship management and cloud business software.",
			currentPrice: 301.24
		),
		Stock(
			symbol: "ADBE",
			name: "Adobe",
			description: "Adobe creates creative, document, and digital experience software.",
			currentPrice: 492.88
		),
		Stock(
			symbol: "PYPL",
			name: "PayPal",
			description: "PayPal provides online payment solutions and financial technology services.",
			currentPrice: 63.41
		),
		Stock(
			symbol: "UBER",
			name: "Uber",
			description: "Uber operates ride sharing, delivery, and mobility platforms.",
			currentPrice: 76.14
		),
		Stock(
			symbol: "SHOP",
			name: "Shopify",
			description: "Shopify provides ecommerce infrastructure for merchants and brands.",
			currentPrice: 78.06
		),
		Stock(
			symbol: "BABA",
			name: "Alibaba",
			description: "Alibaba operates ecommerce, cloud, and digital commerce platforms.",
			currentPrice: 74.82
		),
		Stock(
			symbol: "SONY",
			name: "Sony",
			description: "Sony operates entertainment, gaming, electronics, and financial businesses.",
			currentPrice: 86.29
		),
		Stock(
			symbol: "QCOM",
			name: "Qualcomm",
			description: "Qualcomm develops wireless communication chips and related technologies.",
			currentPrice: 169.37
		),
		Stock(
			symbol: "AVGO",
			name: "Broadcom",
			description: "Broadcom builds semiconductor and enterprise infrastructure software products.",
			currentPrice: 1328.47
		),
		Stock(
			symbol: "ARM",
			name: "Arm",
			description: "Arm designs processor architectures used across mobile and embedded devices.",
			currentPrice: 124.93
		),
		Stock(
			symbol: "MU",
			name: "Micron",
			description: "Micron manufactures memory and storage semiconductor products.",
			currentPrice: 112.57
		),
		Stock(
			symbol: "PLTR",
			name: "Palantir",
			description: "Palantir builds data analytics and decision support software platforms.",
			currentPrice: 24.68
		),
		Stock(
			symbol: "SNOW",
			name: "Snowflake",
			description: "Snowflake provides cloud data platform and analytics infrastructure.",
			currentPrice: 158.73
		),
		Stock(
			symbol: "PANW",
			name: "Palo Alto Networks",
			description: "Palo Alto Networks delivers cybersecurity products and cloud security services.",
			currentPrice: 284.91
		)
	]
}
