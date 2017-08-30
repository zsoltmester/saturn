//
//  Fetchable.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 07. 16..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation

enum FetchError: Error {
	case invalidQuery
	case other(message: String)
}

typealias FetchCompletionHandler = ([News]?, [FetchError]?) -> Void

protocol Fetchable {

	// MARK: - Functions

	func fetch(with query: String?, completionHandler: @escaping FetchCompletionHandler)

}
