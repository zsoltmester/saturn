//
//  QueryExecutor.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 24..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation

typealias QueryResult = [Any]

typealias QueryError = Error

typealias QueryCompletionHandler = (QueryResult?, QueryError?) -> Void

protocol QueryExecutor {

	// MARK: - Functions

	func executeQuery(_: String, completionHandler: @escaping QueryCompletionHandler)

}
