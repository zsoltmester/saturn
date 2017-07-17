//
//  Facebook.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 07. 17..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation

class Facebook: Fetchable {

	// MARK: - Properties

	static let shared = Facebook()

	// MARK: - Initialization

	private init() {
	}

	// MARK: - Fetchable

	func fetch(request: FetchRequest?, completionHandler: @escaping FetchCompletionHandler) {

		// TODO
	}
}
