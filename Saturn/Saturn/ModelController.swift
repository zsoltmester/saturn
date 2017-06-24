//
//  ModelContainer.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 05. 14..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import CoreData
import UIKit

class ModelController {

	// MARK: - Properties

	private static let userDefaultsKeyIsModelPreloaded = "isModelPreloaded"

	var context: NSManagedObjectContext!

	// MARK: - Initialization

	init() {

		let container = NSPersistentContainer(name: "Saturn")
		container.loadPersistentStores(completionHandler: { (_, error) in

			if let error = error as NSError? {
				/*
				Typical reasons for an error here include:
				- The parent directory does not exist, cannot be created, or disallows writing.
				- The persistent store is not accessible, due to permissions or data protection when the device is locked.
				- The device is out of space.
				- The store could not be migrated to the current model version.
				*/
				fatalError("Couldn't load the persistent stores. Error: \(error), \(error.userInfo)")
			}

			self.context = container.viewContext

			let isModelPreloaded = UserDefaults.standard.bool(forKey: ModelController.userDefaultsKeyIsModelPreloaded)
			if !isModelPreloaded {
				self.preloadModel()
				UserDefaults.standard.set(true, forKey: ModelController.userDefaultsKeyIsModelPreloaded)
			}
		})
	}

	private func preloadModel() {

		_ = insertNewsProvider(identifier: NewsProviderIdentifier.twitter.rawValue, name: "Twitter", detail: "Description of Twitter.", hint: "Username")

		/*
		let rssNewsProvider: NewsProvider = insertNewsProvider(identifier: 0, name: "RSS", detail: "Long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long, long description of RSS.", hint: "RSS URL")
		let _: NewsProvider = insertNewsProvider(identifier: 1, name: "Atom", detail: "Description of Atom.", hint: "Atom URL")
		let facebookNewsProvider: NewsProvider = insertNewsProvider(identifier: 2, name: "Facebook", detail: "Description of Facebook.", hint: "Page")
		let _: NewsProvider = insertNewsProvider(identifier: 3, name: "Twitter", detail: "Description of Twitter.", hint: "Username")
		let _: NewsProvider = insertNewsProvider(identifier: 4, name: "Instagram", detail: "Description of Instagram.", hint: "Username")
		let youtubeNewsProvider: NewsProvider = insertNewsProvider(identifier: 5, name: "YouTube", detail: "Description of YouTube.", hint: "Channel")
		let redditNewsProvider: NewsProvider = insertNewsProvider(identifier: 6, name: "Reddit", detail: "Description of Reddit.", hint: "Subreddit")

		var sources = Set<NewsSource>()
		sources.insert(insertNewsSource(provider: facebookNewsProvider, query: "Hearthstone.en"))
		sources.insert(insertNewsSource(provider: youtubeNewsProvider, query: "PlayHearthstone"))
		insertNewsFeed(name: "Hearthstone", colorIdentifier:9, sources: sources)

		sources.removeAll()
		sources.insert(insertNewsSource(provider: rssNewsProvider, query: "http://9gag-rss.com/api/rss/get?code=9GAGHot&format=1", title: "9gag"))
		sources.insert(insertNewsSource(provider: redditNewsProvider, query: "Aww"))
		sources.insert(insertNewsSource(provider: youtubeNewsProvider, query: "VideomaniaFCS"))
		insertNewsFeed(name: "Chill", colorIdentifier:5, sources: sources)

		sources.removeAll()
		sources.insert(insertNewsSource(provider: rssNewsProvider, query: "http://feeds.bbci.co.uk/news/rss.xml?edition=uk", title: "BBC News"))
		sources.insert(insertNewsSource(provider: rssNewsProvider, query: "http://rss.cnn.com/rss/edition.rss", title: "CNN"))
		sources.insert(insertNewsSource(provider: rssNewsProvider, query: "https://www.theguardian.com/uk/rss", title: "The Guardian"))
		sources.insert(insertNewsSource(provider: rssNewsProvider, query: "http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml", title: "The New York Times"))
		insertNewsFeed(name: "International News", colorIdentifier:6, sources: sources)

		sources.removeAll()
		sources.insert(insertNewsSource(provider: redditNewsProvider, query: "Programming"))
		sources.insert(insertNewsSource(provider: rssNewsProvider, query: "https://news.ycombinator.com/rss", title: "Hacker News"))
		insertNewsFeed(name: "Developer's Heaven", colorIdentifier:1, sources: sources)

		sources.removeAll()
		sources.insert(insertNewsSource(provider: rssNewsProvider, query: "http://hvg.hu/rss", title: "hvg.hu"))
		sources.insert(insertNewsSource(provider: rssNewsProvider, query: "http://index.hu/24ora/rss/", title: "Index"))
		sources.insert(insertNewsSource(provider: rssNewsProvider, query: "https://444.hu/feed", title: "444"))
		insertNewsFeed(name: "Daily Essentials", colorIdentifier:4, sources: sources)
		*/
	}

	// MARK: - Public Functions

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
			fatalError("Couldn't insert the news provider. Error: \(error)")
		}

		return newsProvider
	}

	func insertNewsSource(provider: NewsProvider, query: String, title: String? = nil) -> NewsSource {

		let newsSourceEntityDescription = getEntityDescription(for: String(describing: NewsSource.self), in: context)
		guard let newsSource: NewsSource = NSManagedObject(entity: newsSourceEntityDescription, insertInto: context) as? NewsSource else {
			fatalError("Couldn't convert the inserted news source to NewsSource.")
		}
		newsSource.setValue(provider, forKeyPath: #keyPath(NewsSource.provider))
		newsSource.setValue(query, forKeyPath: #keyPath(NewsSource.query))
		newsSource.setValue(title, forKeyPath: #keyPath(NewsSource.title))

		do {
			try context.save()
		} catch let error as NSError {
			fatalError("Couldn't insert the news source. Error: \(error)")
		}

		return newsSource
	}

	func insertNewsFeed(name: String, colorIdentifier: Int16, sources: Set<NewsSource>) {

		let newsFeedEntityDescription = getEntityDescription(for: String(describing: NewsFeed.self), in: context)
		let newsFeed = NSManagedObject(entity: newsFeedEntityDescription, insertInto: context)
		newsFeed.setValue(name, forKeyPath: #keyPath(NewsFeed.name))
		newsFeed.setValue(colorIdentifier, forKey: #keyPath(NewsFeed.colorIdentifier))
		newsFeed.setValue(sources, forKey: #keyPath(NewsFeed.sources))
		newsFeed.setValue(getNewsFeedOrderMin() - 1, forKey: #keyPath(NewsFeed.order))

		do {
			try context.save()
		} catch let error as NSError {
			fatalError("Couldn't insert the news feed. Error: \(error)")
		}
	}

	func deleteNewsFeed(_ feed: NewsFeed) {

		do {
			context.delete(feed)
			try context.save()
		} catch let error as NSError {
			fatalError("Couldn't delete news feed. Error: \(error)")
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
			fatalError("Couldn't fetch a news source. Error: \(error)")
		}
	}

	func getNewsProviders(ordered order: [NSSortDescriptor]) -> [NewsProvider] {

		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NewsProvider.fetchRequest()
		fetchRequest.sortDescriptors = order

		do {
			guard let providers = try context.fetch(fetchRequest) as? [NewsProvider] else {
				fatalError("Couldn't convert the fetched results to [NewsProvider].")
			}
			return providers
		} catch let error as NSError {
			fatalError("Couldn't count the news providers. Error: \(error)")
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
				fatalError("Couldn't convert fetch result to Int16.")
			}
			return newsFeedOrderMin
		} catch let error as NSError {
			fatalError("Couldn't get the news feed orders' minimum. Error: \(error)")
		}
	}

}
