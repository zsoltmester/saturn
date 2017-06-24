//
//  NewsProviderExtension.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 24..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation

extension NewsProvider {

	// MARK: - Properties

	private var queryExecutor: QueryExecutor {

		switch identifier {

		case NewsProviderIdentifier.twitter.rawValue:
			return TwitterQueryExecutor.shared

		default:
			fatalError("Couldn't find news provider for identifier: \(identifier)")
		}
	}

	// MARK: - Public Functions

	func executeQuery(_ query: String) throws -> QueryResult {
		return try queryExecutor.executeQuery(query)
	}

}
