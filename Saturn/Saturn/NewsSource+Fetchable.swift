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
			fatalError("Fetching a NewsSource with a FetchRequest, which won't be used.")
		}

		guard let provider = provider else {
			fatalError("There is a news source without provider: \(self.debugDescription)")
		}

		guard let query = query else {
			fatalError("There is a news source without query: \(self.debugDescription)")
		}

		provider.fetch(request: query, completionHandler: completionHandler)
	}

}
