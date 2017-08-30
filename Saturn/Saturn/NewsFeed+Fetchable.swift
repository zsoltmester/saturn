//
//  NewsFeed+Fetchable.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 07. 10..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation

extension NewsFeed: Fetchable {

	// MARK: - Fetchable

	func fetch(with _: String?, completionHandler: @escaping FetchCompletionHandler) {

		guard let sources = sources?.allObjects as? [NewsSource] else {
			fatalError("Fetching a news feed, but the sources are not valid: \(self.debugDescription)")
		}

		var allResults = [News]()
		var allErrors = [FetchError]()

		let fetchDispatchGroup = DispatchGroup()

		for source in sources {

			fetchDispatchGroup.enter()

			source.fetch(with: nil) { (results: [News]?, errors: [FetchError]?) in

				if let results: [News] = results {
					allResults.append(contentsOf: results)
				}

				if let errors: [FetchError] = errors {
					allErrors.append(contentsOf: errors)
				}

				fetchDispatchGroup.leave()
			}
		}

		fetchDispatchGroup.notify(queue: DispatchQueue.main) {

			completionHandler(allResults, allErrors)
		}

	}

}
