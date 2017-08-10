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

	func fetch(request: FetchRequest?, completionHandler: @escaping FetchCompletionHandler) {

		guard var request = request else {
			fatalError("Fetching a Reddit feed, but the FetchRequest is nil.")
		}

		request = String(format:subredditRssUrlTemplate, request)

		RSS.shared.fetch(request: request, completionHandler: completionHandler)
	}

}
