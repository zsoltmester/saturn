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

	var screenNameMemoryCache = [String: String]()

	// MARK: - Initialization

	private init() {

		TwitterKit.Twitter.sharedInstance().start(withConsumerKey:twitterConsumerKey, consumerSecret:twitterConsumerSecret)
		apiClient = TWTRAPIClient()
	}

	// MARK: - Fetchable

	func fetch(with query: String?, completionHandler: @escaping FetchCompletionHandler) {

		guard let query = query else {
			fatalError("Fetching Twitter without a query.")
		}

		let userTimelineLoader = TWTRUserTimelineDataSource(screenName: query,
		                                                    userID: nil,
		                                                    apiClient: apiClient,
		                                                    maxTweetsPerRequest: UInt(FetchConstants.maxResults),
		                                                    includeReplies: includeReplies,
		                                                    includeRetweets: includeRetweets)

		userTimelineLoader.loadPreviousTweets(beforePosition: nil) { (tweets: [TWTRTweet]?, _, error: Error?) in

			var errors: [FetchError]?
			if let error = error {
				errors = [FetchError.other(message: "Twitter request failed with error: \(error)")]
				completionHandler(nil, errors)
				return
			}

			var news = [News]()

			if let tweets = tweets {

				let sourceScreenName = NSLocalizedString("Twitter:Name", comment: "")
				let retweetTitle = NSLocalizedString("News:Twitter:RetweetTitle", comment: "")

				for var tweet in tweets {

					let aNews = News()

					aNews.avatarUrl = URL(string: tweet.author.profileImageLargeURL)
					aNews.sourceScreenName = sourceScreenName
					aNews.text = tweet.text
					aNews.timestamp = tweet.createdAt

					if tweet.isRetweet, let retweeted = tweet.retweeted {

						aNews.title = String(format: retweetTitle, tweet.author.name, retweeted.author.name)
						tweet = retweeted
					} else {

						aNews.title = tweet.author.name

						self.screenNameMemoryCache[query] = tweet.author.name
					}

					aNews.url = tweet.permalink

					news.append(aNews)
				}
			}

			completionHandler(news, nil)
		}
	}
}
