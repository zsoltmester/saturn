//
//  Facebook.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 07. 17..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import FacebookCore
import FacebookLogin
import Foundation

class Facebook: Fetchable {

	// MARK: - Properties

	static let shared = Facebook()

	private let readPermissions: [ReadPermission] = [ .publicProfile ]

	// MARK: - Initialization

	private init() {
	}

	// MARK: - Fetchable

	func fetch(request: FetchRequest?, completionHandler: @escaping FetchCompletionHandler) {

		guard let request = request else {
			fatalError("Fetching Facebook without a request.")
		}

		let connection = GraphRequestConnection()

		connection.add(GraphRequest(graphPath: "/\(request)/posts")) { _, result in

			switch result {

			case .success(let response):

				guard let posts = response.dictionaryValue?["data"] as? [[String: String]] else {
					fatalError("Couldn't parse Facebook response: \(response)")
				}

				var postsAsString = [String]()
				for post in posts {
					postsAsString.append(post.description)
				}

				completionHandler(postsAsString, nil)

			case .failed(let error):

				completionHandler(nil, [error])
			}
		}

		connection.start()
	}

	// MARK: - Public Functions

	func login(completion: @escaping (LoginResult) -> Void) {

		LoginManager().logIn(readPermissions, viewController: nil, completion: completion)
	}

}
