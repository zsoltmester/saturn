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

	func fetch(request: FetchRequest?, completionHandler: @escaping FetchCompletionHandler) {

		switch identifier {

		case NewsProviderIdentifier.facebook.rawValue:
			Facebook.shared.fetch(request: request, completionHandler: completionHandler)

		case NewsProviderIdentifier.reddit.rawValue:
			Reddit.shared.fetch(request: request, completionHandler: completionHandler)

		case NewsProviderIdentifier.rss.rawValue:
			RSS.shared.fetch(request: request, completionHandler: completionHandler)

		case NewsProviderIdentifier.twitter.rawValue:
			Twitter.shared.fetch(request: request, completionHandler: completionHandler)

		case NewsProviderIdentifier.youtube.rawValue:
			YouTube.shared.fetch(request: request, completionHandler: completionHandler)

		default:
			fatalError("Couldn't find a fetcher for a news provider: \(name ?? "nil"), \(identifier)")
		}
	}

}
