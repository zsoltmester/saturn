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
			fatalError("Fetching Twitter without request.")
		}

		let userTimelineLoader = TWTRUserTimelineDataSource(screenName: request,
		                                                    userID: nil,
		                                                    apiClient: apiClient,
		                                                    maxTweetsPerRequest: 10, // TODO: should be a global config
															includeReplies: true, // TODO: should be a global config
															includeRetweets: true) // TODO: should be a global config

		userTimelineLoader.loadPreviousTweets(beforePosition: nil /* TODO: handle load more */) { (tweets: [TWTRTweet]?, _, error: Error?) in

			// TODO: create news, instead of strings
			var tweetsAsString = [String]()

			if error != nil, let tweets = tweets {

				for tweet in tweets {

					tweetsAsString.append("Author: \(tweet.author) \nCreated: \(tweet.createdAt)") // TODO: Add more property
				}
			}

			completionHandler(tweetsAsString, error)
		}
	}

}
