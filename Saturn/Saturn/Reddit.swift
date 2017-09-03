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

	var screenNameMemoryCache = [String: String]()

	// MARK: - Initialization

	private init() {
	}

}

extension Reddit: Fetchable {

	// MARK: - Fetchable

	func fetch(with query: String?, completionHandler: @escaping FetchCompletionHandler) {

		guard let query = query else {
			fatalError("Fetching Reddit without a query.")
		}

		let subredditUrl = String(format:subredditRssUrlTemplate, query)

		RSS.shared.fetch(with: subredditUrl) { news, errors in

			if errors == nil, let news = news {

				let subredditName = RSS.shared.screenNameMemoryCache[subredditUrl] ?? query

				self.screenNameMemoryCache[query] = subredditName

				let sourceScreenName = String(format: NSLocalizedString("News:Reddit:ScreenName", comment: ""), NSLocalizedString("Reddit:Name", comment: ""), subredditName)

				for aNews in news {

					aNews.sourceScreenName = sourceScreenName
				}
			}

			completionHandler(news, errors)
		}
	}

}
