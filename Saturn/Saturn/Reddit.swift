//
//  Reddit.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 08. 10..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation

private let subredditRssUrlTemplate = "https://www.reddit.com/r/%@/hot/.rss"

class Reddit {

	// MARK: - Properties

	static let shared = Reddit()

	// MARK: - Initialization

	private init() {
	}

}

extension Reddit: Fetchable {

	// MARK: - Fetchable

	func fetch(with query: String?, completionHandler: @escaping FetchCompletionHandler) {

		guard var query = query else {
			fatalError("Fetching Reddit without a query.")
		}

		query = String(format:subredditRssUrlTemplate, query)

		RSS.shared.fetch(with: query, completionHandler: completionHandler)
	}

}
