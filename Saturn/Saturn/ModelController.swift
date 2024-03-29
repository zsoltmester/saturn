//
//  ModelController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 05. 14..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import CoreData
import UIKit

enum ModelError: Error {

	case nameExists
}

class ModelController {

	// MARK: - Properties

	static let shared = ModelController()

	private static let userDefaultsKeyIsModelPreloaded = "isModelPreloaded"

	var context: NSManagedObjectContext!

	// MARK: - Initialization

	private init() {

		let container = NSPersistentContainer(name: "Saturn")
		container.loadPersistentStores { _, error in

			if let error = error as NSError? {
				/*
				Typical reasons for an error here include:
				- The parent directory does not exist, cannot be created, or disallows writing.
				- The persistent store is not accessible, due to permissions or data protection when the device is locked.
				- The device is out of space.
				- The store could not be migrated to the current model version.
				*/
				fatalError("Couldn't load the persistent stores: \(error.debugDescription)")
			}

			self.context = container.viewContext

			let isModelPreloaded = UserDefaults.standard.bool(forKey: ModelController.userDefaultsKeyIsModelPreloaded)
			if !isModelPreloaded {
				self.preloadModel()
				UserDefaults.standard.set(true, forKey: ModelController.userDefaultsKeyIsModelPreloaded)
			}
		}
	}

	private func preloadModel() {
		_ = insertNewsProvider(identifier: NewsProviderIdentifier.facebook.rawValue,
		                       name: NSLocalizedString("Facebook:Name", comment: ""),
		                       detail: NSLocalizedString("FeedEditor:Facebook:Detail", comment: ""),
		                       hint: NSLocalizedString("FeedEditor:Facebook:Hint", comment: ""))

		let reddit = insertNewsProvider(identifier: NewsProviderIdentifier.reddit.rawValue,
		                                name: NSLocalizedString("Reddit:Name", comment: ""),
		                                detail: NSLocalizedString("FeedEditor:Reddit:Detail", comment: ""),
		                                hint: NSLocalizedString("FeedEditor:Reddit:Hint", comment: ""))

		let rss = insertNewsProvider(identifier: NewsProviderIdentifier.rss.rawValue,
		                             name: NSLocalizedString("RSS:Name", comment: ""),
		                             detail: NSLocalizedString("FeedEditor:RSS:Detail", comment: ""),
		                             hint: NSLocalizedString("FeedEditor:RSS:Hint", comment: ""))

		let twitter = insertNewsProvider(identifier: NewsProviderIdentifier.twitter.rawValue,
		                                 name: NSLocalizedString("Twitter:Name", comment: ""),
		                                 detail: NSLocalizedString("FeedEditor:Twitter:Detail", comment: ""),
		                                 hint: NSLocalizedString("FeedEditor:Twitter:Hint", comment: ""))

		let youTube = insertNewsProvider(identifier: NewsProviderIdentifier.youtube.rawValue,
		                                 name: NSLocalizedString("YouTube:Name", comment: ""),
		                                 detail: NSLocalizedString("FeedEditor:YouTube:Detail", comment: ""),
		                                 hint: NSLocalizedString("FeedEditor:YouTube:Hint", comment: ""))

		/* for testing
		let hackerNews = insertNewsSource(provider: rss, query: "https://news.ycombinator.com/rss", name: "Hacker News")
		let redditProgramming = insertNewsSource(provider: reddit, query: "programming", name: "programming")
		_ = try? insertNewsFeed(name: "Programming", sources: [hackerNews, redditProgramming])

		let gameOfThronesTwitter = insertNewsSource(provider: twitter, query: "GameOfThrones", name: "Game Of Thrones")
		let gameOfThronesYouTube = insertNewsSource(provider: youTube, query: "GameofThrones", name: "GameofThrones")
		_ = try? insertNewsFeed(name: "Game Of Thrones", sources: [gameOfThronesTwitter, gameOfThronesYouTube])

		let unboxTherapy = insertNewsSource(provider: youTube, query: "unboxtherapy", name: "Unbox Therapy")
		_ = try? insertNewsFeed(name: "Chill", sources: [unboxTherapy])

		let macworld = insertNewsSource(provider: rss, query: "http://www.macworld.co.uk/news/apple/rss", name: "Latest Apple News Articles from Macworld UK")
		let everythingApplePro = insertNewsSource(provider: youTube, query: "EverythingApplePro", name: "EverythingApplePro")
		_ = try? insertNewsFeed(name: "Apple", sources: [macworld, everythingApplePro])
		*/
	}

	// MARK: - Public Functions

	// MARK: Create

	func insertNewsProvider(identifier: Int16, name: String, detail: String, hint: String) -> NewsProvider {

		let newsProviderEntityDescription = getEntityDescription(for: String(describing: NewsProvider.self), in: context)
		guard let newsProvider: NewsProvider = NSManagedObject(entity: newsProviderEntityDescription, insertInto: context) as? NewsProvider else {
			fatalError("Couldn't convert the inserted news provider to NewsProvider.")
		}
		newsProvider.setValue(identifier, forKeyPath: #keyPath(NewsProvider.identifier))
		newsProvider.setValue(name, forKeyPath: #keyPath(NewsProvider.name))
		newsProvider.setValue(detail, forKeyPath: #keyPath(NewsProvider.detail))
		newsProvider.setValue(hint, forKeyPath: #keyPath(NewsProvider.hint))

		do {
			try context.save()
		} catch let error as NSError {
			fatalError("Couldn't insert the news provider: \(error.debugDescription)")
		}

		return newsProvider
	}

	func insertNewsSource(provider: NewsProvider, query: String, name: String? = nil) -> NewsSource {

		let newsSourceEntityDescription = getEntityDescription(for: String(describing: NewsSource.self), in: context)
		guard let newsSource: NewsSource = NSManagedObject(entity: newsSourceEntityDescription, insertInto: context) as? NewsSource else {
			fatalError("Couldn't convert the inserted news source to NewsSource.")
		}
		newsSource.setValue(provider, forKeyPath: #keyPath(NewsSource.provider))
		newsSource.setValue(query, forKeyPath: #keyPath(NewsSource.query))
		newsSource.setValue(name, forKeyPath: #keyPath(NewsSource.name))

		do {
			try context.save()
		} catch let error as NSError {
			fatalError("Couldn't insert the news source: \(error.debugDescription)")
		}

		return newsSource
	}

	func insertNewsFeed(name: String, sources: Set<NewsSource>) throws -> NewsFeed {

		let newsFeedEntityDescription = getEntityDescription(for: String(describing: NewsFeed.self), in: context)
		guard let newsFeed = NSManagedObject(entity: newsFeedEntityDescription, insertInto: context) as? NewsFeed else {
			fatalError("Couldn't convert the inserted news feed to NewsFeed.")
		}
		newsFeed.setValue(name, forKeyPath: #keyPath(NewsFeed.name))
		newsFeed.setValue(sources, forKey: #keyPath(NewsFeed.sources))
		newsFeed.setValue(getNewsFeedOrderMin() - Int16(1), forKey: #keyPath(NewsFeed.order))

		do {
			try context.save()
		} catch let error as NSError {

			if isErrorContainsNameConflict(error) {

				deleteNewsFeed(newsFeed)
				throw ModelError.nameExists
			}

			fatalError("Couldn't insert the news feed: \(error.debugDescription)")
		}

		return newsFeed
	}

	// MARK: Read

	func getNewsProviders(ordered order: [NSSortDescriptor]) -> [NewsProvider] {

		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NewsProvider.fetchRequest()
		fetchRequest.sortDescriptors = order

		do {
			guard let providers = try context.fetch(fetchRequest) as? [NewsProvider] else {
				fatalError("Couldn't convert the fetched results to [NewsProvider].")
			}
			return providers
		} catch let error as NSError {
			fatalError("Couldn't count the news providers: \(error.debugDescription)")
		}
	}

	func getNewsSource(provider: NewsProvider, query: String) -> NewsSource? {

		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NewsSource.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "\(#keyPath(NewsSource.provider.identifier)) == \"\(provider.identifier)\" AND \(#keyPath(NewsSource.query)) == \"\(query)\"")

		do {
			guard let sources = try context.fetch(fetchRequest) as? [NewsSource] else {
				fatalError("Couldn't convert the fetched results to [NewsSource].")
			}
			return sources.first
		} catch let error as NSError {
			fatalError("Couldn't fetch a news source: \(error.debugDescription)")
		}
	}

	// MARK: Update

	func updateNewsSource(_ source: NewsSource, name: String?, provider: NewsProvider?) -> NewsSource {

		let previousName = source.name
		let previousProvider = source.provider

		if let name = name {
			source.setValue(name, forKey:#keyPath(NewsSource.name))
		}

		if let provider = provider {
			source.setValue(provider, forKey:#keyPath(NewsSource.provider))
		}

		do {
			try context.save()
		} catch let error as NSError {

			do {
				source.setValue(previousName, forKey:#keyPath(NewsSource.name))
				source.setValue(previousProvider, forKey:#keyPath(NewsSource.provider))
				try context.save()
			} catch let error as NSError {
				fatalError("Couldn't rollback source while updating it: \(error.debugDescription)")
			}

			fatalError("Couldn't update the news source: \(error.debugDescription)")
		}

		return source
	}

	func updateNewsFeed(_ feed: NewsFeed, name: String?, sources: Set<NewsSource>?) throws -> NewsFeed {

		let previousName = feed.name
		let previousSources = feed.sources

		if let name = name {
			feed.setValue(name, forKey:#keyPath(NewsFeed.name))
		}

		if let sources = sources {
			feed.setValue(sources, forKey:#keyPath(NewsFeed.sources))
		}

		do {
			try context.save()
		} catch let error as NSError {

			if isErrorContainsNameConflict(error) {

				do {
					feed.setValue(previousName, forKey:#keyPath(NewsFeed.name))
					feed.setValue(previousSources, forKey:#keyPath(NewsFeed.sources))
					try context.save()
				} catch let error as NSError {
					fatalError("Couldn't rollback feed while updating it and the name conflicted: \(error.debugDescription)")
				}

				throw ModelError.nameExists
			}

			fatalError("Couldn't update the news feed: \(error.debugDescription)")
		}

		return feed
	}

	// MARK: Delete

	func deleteNewsFeed(_ feed: NewsFeed) {

		do {
			context.delete(feed)
			try context.save()
		} catch let error as NSError {
			fatalError("Couldn't delete news feed: \(error.debugDescription)")
		}
	}

	// MARK: - Private Functions

	private func getEntityDescription(for entityName: String, in context: NSManagedObjectContext) -> NSEntityDescription {

		guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
			fatalError("Couldn't find entity with name: \(entityName)")
		}

		return entityDescription
	}

	private func getNewsFeedOrderMin() -> Int16 {

		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NewsFeed.fetchRequest()
		fetchRequest.resultType = .dictionaryResultType

		let expressionForNewsFeedOrderMin = NSExpression(forFunction: "min:", arguments: [NSExpression(forKeyPath: #keyPath(NewsFeed.order))])

		let propertyNameForNewsFeedOrderMin = "newsFeedOrderMin"

		let propertyDescriptionForNewsFeedOrderMin = NSExpressionDescription()
		propertyDescriptionForNewsFeedOrderMin.name = propertyNameForNewsFeedOrderMin
		propertyDescriptionForNewsFeedOrderMin.expression = expressionForNewsFeedOrderMin
		propertyDescriptionForNewsFeedOrderMin.expressionResultType = .integer16AttributeType

		fetchRequest.propertiesToFetch = [propertyDescriptionForNewsFeedOrderMin]

		do {
			guard let newsFeedOrderMin: Int16 = try (context.fetch(fetchRequest) as? [[String: Int16]])?.first?[propertyNameForNewsFeedOrderMin] else {
				fatalError("Couldn't convert fetched news feed order min to Int16.")
			}
			return newsFeedOrderMin
		} catch let error as NSError {
			fatalError("Couldn't get the news feed order min: \(error.debugDescription)")
		}
	}

	private func isErrorContainsNameConflict(_ error: NSError) -> Bool {

		if let conflictList = error.userInfo["conflictList"] as? [NSConstraintConflict] {

			for conflict in conflictList {

				if conflict.constraint.contains("name") {

					return true
				}
			}
		}

		return false
	}

}
