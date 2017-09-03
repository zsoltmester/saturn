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

	var screenNameMemoryCache = [String: String]()

	// MARK: - Initialization

	private init() {
	}

}

extension RSS: Fetchable {

	// MARK: - Fetchable

	func fetch(with query: String?, completionHandler: @escaping FetchCompletionHandler) {

		guard let query = query else {
			fatalError("Fetching RSS without a query.")
		}

		guard let url = URL(string: query), let parser = FeedParser(URL: url) else {
			completionHandler(nil, [FetchError.invalidQuery])
			return
		}

		parser.parseAsync { result in

			switch result {
			case let .rss(feed):
				self.screenNameMemoryCache[query] = feed.title
				completionHandler(self.getNews(from: feed), nil)
			case let .atom(feed):
				self.screenNameMemoryCache[query] = feed.title
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
			aNews.sourceScreenName = feed.title

			if let link = item.link {

				aNews.url = URL(string: link)
			}

			aNews.text = item.description

			if let imageLink = item.enclosure?.attributes?.url, let imageUrl = URL(string: imageLink) {

				aNews.avatarUrl = imageUrl

			}

			if aNews.avatarUrl == nil, let media = item.media?.mediaContents, !media.isEmpty {

				for aMedia in media {

					if aMedia.attributes?.medium?.range(of: "image") != nil, let mediaLink = aMedia.attributes?.url, let mediaUrl = URL(string: mediaLink) {

						aNews.avatarUrl = mediaUrl
						break
					}
				}
			}

			if aNews.avatarUrl == nil, let avatarLink = feed.image?.url {

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

		var news = [News]()

		for item in items {

			let aNews = News()

			aNews.title = item.title
			aNews.timestamp = item.published ?? item.updated
			aNews.sourceScreenName = feed.title

			if let link = item.links?.first?.attributes?.href {

				aNews.url = URL(string: link)
			}

			if item.content?.attributes?.type?.lowercased().range(of: "text") != nil {

				aNews.text = item.content?.value
			}

			if let iconLink = feed.icon, let iconUrl = URL(string: iconLink) {

				aNews.avatarUrl = iconUrl

			} else if let logoLink = feed.logo, let logoUrl = URL(string: logoLink) {

				aNews.avatarUrl = logoUrl
			}

			news.append(aNews)
		}

		return news
	}
}
