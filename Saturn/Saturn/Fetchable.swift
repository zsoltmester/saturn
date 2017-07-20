//
//  Fetchable.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 07. 16..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation

typealias FetchRequest = String

typealias FetchResult = String

typealias FetchError = Error

typealias FetchCompletionHandler = ([FetchResult]?, [FetchError]?) -> Void

protocol Fetchable {

	// MARK: - Functions

	func fetch(request: FetchRequest?, completionHandler: @escaping FetchCompletionHandler)

}
