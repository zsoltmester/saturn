//
//  RSS.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 08. 06..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

// FeedKit source: https://github.com/nmdias/FeedKit
// FeedKit documentation: http://cocoadocs.org/docsets/FeedKit

import FeedKit
import Foundation

class RSS {

	// MARK: - Properties

	static let shared = RSS()

	// MARK: - Initialization

	private init() {
	}

}

extension RSS: Fetchable {

	// MARK: - Fetchable

	func fetch(request: FetchRequest?, completionHandler: @escaping FetchCompletionHandler) {

		guard let request = request else {
			fatalError("Fetching an RSS feed, but the FetchRequest is nil.")
		}

		guard let url = URL(string: request), let parser = FeedParser(URL: url) else {
			completionHandler(nil, [FetchError.invalidQuery])
			return
		}

		parser.parseAsync { result in

			switch result {
			case let .rss(feed):
				completionHandler(self.getNews(from: feed), nil)
			case let .atom(feed):
				completionHandler(self.getNews(from: feed), nil)
			case .json:
				completionHandler(nil, [FetchError.other(message: "Unsupported RSS feed type: JSON.")])
			case let .failure(error):
				completionHandler(nil, [FetchError.other(message: "Error while fetching an RSS feed: \(error)")])
			}

		}
	}

	// MARK: - Private Functions

	private func getNews(from feed: RSSFeed) -> [News] {

		guard let items = feed.items, !items.isEmpty else {
			return [News]()
		}

		var news = [News]()

		for item in items {

			let aNews = News()

			aNews.title = item.title
			aNews.timestamp = item.pubDate

			if let link = item.link {

				aNews.url = URL(string: link)
			}

			aNews.text = item.description

			if let imageLink = item.enclosure?.attributes?.url, let imageUrl = URL(string: imageLink) {

				aNews.avatarUrl = imageUrl

			} else if let avatarLink = feed.image?.url {

				aNews.avatarUrl = URL(string: avatarLink)
			}

			news.append(aNews)
		}

		return news
	}

	private func getNews(from feed: AtomFeed) -> [News] {

		guard let items = feed.entries, !items.isEmpty else {
			return [News]()
		}

		/*var newsAsString = [String]()

		for item in items {

			newsAsString.append("\(item.title ?? "nil"): \(item.summary?.value ?? "nil")")
		}*/

		return [News]()
	}
}
