//
//  NewsSource+Fetchable.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 24..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation

extension NewsSource: Fetchable {

	// MARK: - Fetchable

	func fetch(request: FetchRequest?, completionHandler: @escaping FetchCompletionHandler) {

		guard request == nil else {
			fatalError("Fetching a news source with a request, which won't be used.")
		}

		guard let provider = provider else {
			fatalError("No provider for a news source.")
		}

		guard let query = query else {
			fatalError("No query for a news source.")
		}

		provider.fetch(request: query, completionHandler: completionHandler)
	}

}
