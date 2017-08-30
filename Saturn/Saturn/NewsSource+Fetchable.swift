//
//  NewsSource+Fetchable.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 24..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation

extension NewsSource: Fetchable {

	// MARK: - Public Functions

	func updateName() {

		guard let query = query else {
			fatalError("There is a news source without query: \(self.debugDescription)")
		}

		if let newName = provider?.screenName(for: query) {

			_ = ModelController.shared.updateNewsSource(self, name: newName, provider: nil)
		}
	}

	// MARK: - Fetchable

	func fetch(with _: String?, completionHandler: @escaping FetchCompletionHandler) {

		guard let provider = provider else {
			fatalError("There is a news source without provider: \(self.debugDescription)")
		}

		guard let query = query else {
			fatalError("There is a news source without query: \(self.debugDescription)")
		}

		provider.fetch(with: query) { news, errors in

			for aNews in news ?? [News]() {
				aNews.source = self
			}

			completionHandler(news, errors)
		}
	}

}
