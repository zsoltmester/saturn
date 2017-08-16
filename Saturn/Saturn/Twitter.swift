//
//  Twitter.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 07. 16..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

// TwitterKit documentation: https://dev.twitter.com/twitterkit/ios/overview

import Foundation
import TwitterKit

class Twitter: Fetchable {

	// MARK: - Properties

	private let twitterConsumerKey = "TqDzFgxlfJITqE6rMv66nU0ci"
	private let twitterConsumerSecret = "HgvP8uZYO7iTZmZL3R9MHg3XLq5cEzuACzpii5jz2PdAD2HOT7"

	private let includeReplies = false
	private let includeRetweets = false

	static let shared = Twitter()

	private var apiClient: TWTRAPIClient

	// MARK: - Initialization

	private init() {

		TwitterKit.Twitter.sharedInstance().start(withConsumerKey:twitterConsumerKey, consumerSecret:twitterConsumerSecret)
		apiClient = TWTRAPIClient()
	}

	// MARK: - Fetchable

	func fetch(request: FetchRequest?, completionHandler: @escaping FetchCompletionHandler) {

		guard let request = request else {
			fatalError("Fetching Twitter without a FetchRequest.")
		}

		let userTimelineLoader = TWTRUserTimelineDataSource(screenName: request,
		                                                    userID: nil,
		                                                    apiClient: apiClient,
		                                                    maxTweetsPerRequest: UInt(FetchConstants.maxResults),
		                                                    includeReplies: includeReplies,
		                                                    includeRetweets: includeRetweets)

		userTimelineLoader.loadPreviousTweets(beforePosition: nil) { (tweets: [TWTRTweet]?, _, error: Error?) in

			var errors: [FetchError]?
			if let error = error {
				errors = [FetchError.other(message: "Twitter request failed with error: \(error)")]
			}

			var news = [News]()

			if let tweets = tweets {
				for tweet in tweets {
					let aNews = News()
					aNews.timestamp = tweet.createdAt
					aNews.avatarUrl = URL(string: tweet.author.profileImageURL)
					aNews.title = tweet.author.name
					aNews.text = tweet.text
					news.append(aNews)
				}
			}

			completionHandler(news, errors)
		}
	}

}
