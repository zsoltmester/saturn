//
//  QueryExecutor.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 24..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation

protocol QueryExecutor {

	// MARK: - Functions

	func executeQuery(_: String) throws -> QueryResult
}
