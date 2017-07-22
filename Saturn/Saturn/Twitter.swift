//
//  Twitter.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 07. 16..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation
import TwitterKit

class Twitter: Fetchable {

	// MARK: - Properties

	private let twitterConsumerKey = "TqDzFgxlfJITqE6rMv66nU0ci"
	private let twitterConsumerSecret = "HgvP8uZYO7iTZmZL3R9MHg3XLq5cEzuACzpii5jz2PdAD2HOT7"

	private let includeReplies = true
	private let includeRetweets = true

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

			var tweetsAsString = [String]()
			if let tweets = tweets {
				for tweet in tweets {
					tweetsAsString.append(tweet.description)
				}
			}

			completionHandler(tweetsAsString, errors)
		}
	}

}
