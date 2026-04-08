//
//  StockHeaderSortButton.swift
//  StockPriceTrackerApp
//
//  Created by Taimoor Suleman on 03/04/2026.
//

import SwiftUI

/// Reusable sortable table header button used by the stocks list.
/// It shows the active sort direction for the selected column.
struct StockHeaderSortButton: View {

	// MARK: Properties

	let title: String
	let isSelected: Bool
	let isAscending: Bool
	let action: () -> Void
	let alignment: Alignment

	// MARK: View

	var body: some View {
		Button(action: action) {
			HStack(spacing: 4) {
				if alignment == .trailing {
					Spacer(minLength: 0)
				}

				Text(title)
					.font(.caption)
					.fontWeight(isSelected ? .semibold : .medium)
					.foregroundStyle(isSelected ? .primary : .secondary)
					.lineLimit(1)
					.minimumScaleFactor(0.7)

				if isSelected {
					Image(systemName: isAscending ? "arrow.up" : "arrow.down")
						.font(.caption2)
						.foregroundStyle(.secondary)
				}

				if alignment == .leading {
					Spacer(minLength: 0)
				}
			}
			.frame(maxWidth: .infinity, alignment: alignment)
		}
		.buttonStyle(.plain)
	}
}
