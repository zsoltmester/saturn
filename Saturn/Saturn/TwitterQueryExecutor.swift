//
//  TwitterHelper.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 24..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation

class TwitterQueryExecutor: QueryExecutor {

	// MARK: - Properties

	static let shared = TwitterQueryExecutor()

	// MARK: - Initialization

	private init() {
	}

	// MARK: - NewsProviderHelper

	func executeQuery(_: String) throws -> QueryResult {

		// TODO: implement this function

		return QueryResult()
	}
}
