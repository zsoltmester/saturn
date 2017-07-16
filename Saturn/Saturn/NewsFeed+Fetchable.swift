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

	func fetch(request: FetchRequest?, completionHandler: @escaping FetchCompletionHandler) {

		guard request == nil else {
			fatalError("Fetching a news feed with a request, which won't be used.")
		}

		guard let sources = sources?.allObjects as? [NewsSource] else {
			fatalError("Fetching a news feed, but the sources are not valid.")
		}

		var fetchResults = [FetchResults]()
		var fetchErrors = [FetchError]()

		let fetchDispatchGroup = DispatchGroup()

		for source in sources {

			fetchDispatchGroup.enter()

			source.fetch(request: nil, completionHandler: { (results: FetchResults?, error: FetchError?) in

				if let results: FetchResults = results {
					fetchResults.append(results)
				}

				if let error: FetchError = error {
					fetchErrors.append(error)
				}

				fetchDispatchGroup.leave()
			})
		}

		fetchDispatchGroup.notify(queue: DispatchQueue.main) {

			let results: FetchResults? = self.mergeFetchResults(results: fetchResults)
			let error: FetchError? = self.mergeFetchErrors(errors: fetchErrors)
			completionHandler(results, error)
		}

	}

	// MARK: - Private Functions

	func mergeFetchResults(results: [FetchResults]) -> FetchResults? {
		// TODO
		return nil
	}

	func mergeFetchErrors(errors: [FetchError]) -> FetchError? {
		// TODO
		return nil
	}

}
