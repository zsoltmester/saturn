//
//  RSS.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 08. 06..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation

class RSS {

	// MARK: - Properties

	static let shared = RSS()

	// MARK: - Initialization

	private init() {
	}

}

extension RSS: Fetchable {

	// MARK: - Fetchable

	func fetch(request: FetchRequest?, completionHandler: @escaping FetchCompletionHandler) {
		print("RSS-t fetchelne...")
	}
}
