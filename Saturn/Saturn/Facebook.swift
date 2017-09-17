//
//  Facebook.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 07. 17..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

// App Dashboard: https://developers.facebook.com/apps/325772207834932/dashboard/
// Facebook API docs: https://developers.facebook.com/docs/graph-api/reference
// Facebook API explorer: https://developers.facebook.com/tools/explorer
// Used services: https://developers.facebook.com/docs/graph-api/reference/v2.10/user, /user/picture/, /user/feed
// Maybe useful in the future: /attachments

import FacebookCore
import FacebookLogin
import Foundation

class Facebook {

	// MARK: - Properties

	static let shared = Facebook()

	private let readPermissions: [ReadPermission] = [ .publicProfile ]

	var screenNameMemoryCache = [String: String]()

	// MARK: - Initialization

	private init() {
	}

	// MARK: - Public Functions

	func login(completion: @escaping (LoginResult) -> Void) {

		LoginManager().logIn(readPermissions, viewController: nil, completion: completion)
	}

}

extension Facebook: Fetchable {

	// MARK: - Fetchable

	func fetch(with query: String?, completionHandler: @escaping FetchCompletionHandler) {

		guard let page = query else {
			fatalError("Fetching Facebook without a query.")
		}

		fetchPageScreenName(page, fetchCompletionHandler: completionHandler) { pageScreenName in

			self.screenNameMemoryCache[page] = pageScreenName

			self.fetchPosts(for: page, fetchCompletionHandler: completionHandler) { posts in

				var news = [News]()

				let avatarUrl = URL(string: String(format: FacebookApi.linkToProfilePicture, page))
				let sourceScreenName = NSLocalizedString("Facebook:Name", comment: "")

				for post in posts {

					let aNews = News()
					aNews.avatarUrl = avatarUrl
					aNews.sourceScreenName = sourceScreenName
					aNews.text = post[FacebookApi.PageFeedService.ResponseField.message]
					aNews.timestamp = FacebookApi.dateFormatter.date(from: post[FacebookApi.PageFeedService.ResponseField.createdTime] ?? "")
					aNews.title = post[FacebookApi.PageFeedService.ResponseField.story] ?? self.screenNameMemoryCache[page]

					if let postId = post[FacebookApi.PageFeedService.ResponseField.postId] {
						aNews.url = URL(string: String(format: FacebookApi.linkToPost, postId))
					}

					news.append(aNews)
				}

				completionHandler(news, nil)
			}
		}
	}

	// MARK: - Private Functions

	private func fetchPageScreenName(_ page: String, fetchCompletionHandler: @escaping FetchCompletionHandler, completion: @escaping (String) -> Void) {

		let connection = GraphRequestConnection()

		connection.add(GraphRequest(graphPath: String(format: FacebookApi.PageInfoService.path, page), parameters: FacebookApi.PageInfoService.parameters)) { _, result in

			switch result {

			case .success(let response):

				var pageScreenName = (response.dictionaryValue?[FacebookApi.PageInfoService.ResponseField.name] as? String) ?? ""

				if pageScreenName.isEmpty {
					pageScreenName = page
				}

				completion(pageScreenName)

			case .failed(let error):

				fetchCompletionHandler(nil, [FetchError.other(message: "Facebook service failed with error: \(error)")])
			}

		}

		connection.start()
	}

	private func fetchPosts(for page: String, fetchCompletionHandler: @escaping FetchCompletionHandler, completion: @escaping ([[String: String]]) -> Void) {

		let connection = GraphRequestConnection()

		connection.add(GraphRequest(graphPath: String(format: FacebookApi.PageFeedService.path, page), parameters: FacebookApi.PageFeedService.parameters)) { _, result in

			switch result {

			case .success(let response):

				guard let posts = response.dictionaryValue?[FacebookApi.CommonResponseField.data] as? [[String: String]] else {
					fetchCompletionHandler(nil, [FetchError.other(message: "Couldn't parse a Facebook response: \(response)")])
					return
				}

				completion(posts)

			case .failed(let error):

				fetchCompletionHandler(nil, [FetchError.other(message: "Facebook service failed with error: \(error)")])
			}
		}

		connection.start()
	}

}

private struct FacebookApi {

	static let dateFormatter = ISO8601DateFormatter()
	static let linkToPost = "https://www.facebook.com/%@"
	static let linkToProfilePicture = "https://graph.facebook.com/%@/picture?type=large"

	struct CommonResponseField {

		static let data = "data"
	}

	struct PageInfoService {

		static let path = "%@"

		static let parameters = ["fields": "name"]

		struct ResponseField {

			static let name = "name"

		}

	}

	struct PageFeedService {

		static let path = "%@/posts"

		static let parameters = ["fields": "created_time, id, message, story"]

		struct ResponseField {

			static let createdTime = "created_time"
			static let postId = "id"
			static let message = "message"
			static let story = "story"

		}

	}

}
