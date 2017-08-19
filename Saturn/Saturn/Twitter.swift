//
//  Twitter.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 07. 16..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

// TwitterKit documentation: https://dev.twitter.com/twitterkit/ios/overview
// TwitterKit API explorer: https://dev.twitter.com/rest/tools/console

import Foundation
import TwitterKit

class Twitter: Fetchable {

	// MARK: - Properties

	private let twitterConsumerKey = "TqDzFgxlfJITqE6rMv66nU0ci"
	private let twitterConsumerSecret = "HgvP8uZYO7iTZmZL3R9MHg3XLq5cEzuACzpii5jz2PdAD2HOT7"

	private let includeReplies = false
	private let includeRetweets = true

	static let shared = Twitter()

	private var apiClient: TWTRAPIClient

	private lazy var twitterResourceBundle: Bundle = {

		let twitterBundle = Bundle(for: TWTRTweet.self)
		guard let twitterResourceBundleUrl = twitterBundle.resourceURL?.appendingPathComponent("TwitterKitResources.bundle") else {
			fatalError("Unable to load the Twitter resource bundle's URL.")
		}
		guard let twitterResourceBundle = Bundle(url: twitterResourceBundleUrl) else {
			fatalError("Unable to load the Twitter resource bundle.")
		}
		return twitterResourceBundle
	}()

	lazy var errorImage: UIImage = {

		guard let image = UIImage(named: "twttr-icn-tweet-place-holder-photo-error.png", in: self.twitterResourceBundle, compatibleWith: nil) else {
			fatalError("Unable to load the Twitter's error image.")
		}
		return image
	}()

	lazy var placeholderImage: UIImage = {

		guard let image = UIImage(named: "twttr-icn-tweet-place-holder-photo.png", in: self.twitterResourceBundle, compatibleWith: nil) else {
			fatalError("Unable to load the Twitter's placeholder image.")
		}
		return image
	}()

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
				for var tweet in tweets {

					let aNews = News()

					if tweet.isRetweet, let retweeted = tweet.retweeted {

						aNews.title = String(format: NSLocalizedString("News:Twitter:RetweetTitle", comment: ""), retweeted.author.name, tweet.author.name)
						tweet = retweeted
					} else {

						aNews.title = tweet.author.name
					}

					aNews.timestamp = tweet.createdAt
					aNews.avatarUrl = URL(string: tweet.author.profileImageLargeURL)
					aNews.text = tweet.text
					news.append(aNews)
				}
			}

			completionHandler(news, errors)
		}
	}
}
