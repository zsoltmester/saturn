//
//  NewsSourceExtension.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 24..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import UIKit

typealias CreateNewsSourceCompletionHandler = (NewsSource?, QueryError?) -> Void

extension NewsSource {

	// MARK: - Public Functions

	static func create(provider: NewsProvider, query: String, completionHandler: @escaping CreateNewsSourceCompletionHandler) {

		provider.queryExecutor.executeQuery(query) { (_, error: QueryError?) in

			var source: NewsSource?

			if error == nil {

				source = AppDelegate.get().modelController.getNewsSource(provider: provider, query: query)
				if source == nil {
					source = AppDelegate.get().modelController.insertNewsSource(provider: provider, query: query)
				}
			}

			completionHandler(source, error)
		}
	}

}
