//
//  NewsProvider+Fetchable.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 24..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation

extension NewsProvider: Fetchable {

	// MARK: - Fetchable

	func fetch(with query: String?, completionHandler: @escaping FetchCompletionHandler) {

		switch identifier {

		case NewsProviderIdentifier.facebook.rawValue:
			Facebook.shared.fetch(with: query, completionHandler: completionHandler)

		case NewsProviderIdentifier.reddit.rawValue:
			Reddit.shared.fetch(with: query, completionHandler: completionHandler)

		case NewsProviderIdentifier.rss.rawValue:
			RSS.shared.fetch(with: query, completionHandler: completionHandler)

		case NewsProviderIdentifier.twitter.rawValue:
			Twitter.shared.fetch(with: query, completionHandler: completionHandler)

		case NewsProviderIdentifier.youtube.rawValue:
			YouTube.shared.fetch(with: query, completionHandler: completionHandler)

		default:
			fatalError("Couldn't find a fetcher for a news provider: \(name ?? "nil"), \(identifier)")
		}
	}

}
