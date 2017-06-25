//
//  TwitterHelper.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 24..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation
import TwitterKit

class TwitterQueryExecutor: QueryExecutor {

	// MARK: - Properties

	private let twitterConsumerKey = "TqDzFgxlfJITqE6rMv66nU0ci"
	private let twitterConsumerSecret = "HgvP8uZYO7iTZmZL3R9MHg3XLq5cEzuACzpii5jz2PdAD2HOT7"

	static let shared = TwitterQueryExecutor()

	private var apiClient: TWTRAPIClient

	// MARK: - Initialization

	private init() {

		Twitter.sharedInstance().start(withConsumerKey:twitterConsumerKey, consumerSecret:twitterConsumerSecret)
		apiClient = TWTRAPIClient()
	}

	// MARK: - QueryExecutor

	func executeQuery(_ query: String, completionHandler: @escaping QueryCompletionHandler) {

		let userTimelineLoader = TWTRUserTimelineDataSource(screenName: query,
		                                                    userID: nil,
		                                                    apiClient: apiClient,
		                                                    maxTweetsPerRequest: 10, // TODO: should be configurable and global
		                                                    includeReplies: true,
		                                                    includeRetweets: true)

		// TODO: handle load more

		userTimelineLoader.loadPreviousTweets(beforePosition: nil) { (tweets: [TWTRTweet]?, _, error: Error?) in
			completionHandler(tweets, error)
		}
	}

}
