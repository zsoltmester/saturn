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

		var sources = Set<NewsSource>()
		sources.insert(insertNewsSource(provider: "Battle.net", service: "Hearthstone"))
		insertNewsFeed(name: "Hearthstone", colorIdentifier:9, sources: sources)

		sources.removeAll()
		sources.insert(insertNewsSource(provider: "9gag", service: "9gag"))
		sources.insert(insertNewsSource(provider: "Reddit", service: "Aww"))
		sources.insert(insertNewsSource(provider: "Youtube", service: "Videómánia"))
		insertNewsFeed(name: "Chill", colorIdentifier:5, sources: sources)

		sources.removeAll()
		sources.insert(insertNewsSource(provider: "BBC News", service: "BBC News"))
		sources.insert(insertNewsSource(provider: "CNN", service: "CNN"))
		sources.insert(insertNewsSource(provider: "Telegraph", service: "Telegraph"))
		sources.insert(insertNewsSource(provider: "The Guardian", service: "The Guardian"))
		sources.insert(insertNewsSource(provider: "The New York Times", service: "The New York Times"))
		insertNewsFeed(name: "International News", colorIdentifier:6, sources: sources)

		sources.removeAll()
		sources.insert(insertNewsSource(provider: "Reddit", service: "Programming"))
		sources.insert(insertNewsSource(provider: "Hacker News", service: "Hacker News"))
		insertNewsFeed(name: "Developer's Heaven", colorIdentifier:1, sources: sources)

		sources.removeAll()
		sources.insert(insertNewsSource(provider: "HVG", service: "HVG"))
		sources.insert(insertNewsSource(provider: "Index", service: "Index"))
		sources.insert(insertNewsSource(provider: "444", service: "444"))
		insertNewsFeed(name: "Daily Essentials", colorIdentifier:4, sources: sources)
	}

	// MARK: - Public Functions

	func insertNewsSource(provider: String, service: String) -> NewsSource {

		let newsSourceEntityDescription = getEntityDescription(for: String(describing: NewsSource.self), in: context)
		guard let newsSource: NewsSource = NSManagedObject(entity: newsSourceEntityDescription, insertInto: context) as? NewsSource else {
			fatalError("Couldn't convert the inserted news source to NewsSource.")
		}
		newsSource.setValue(provider, forKeyPath: #keyPath(NewsSource.provider))
		newsSource.setValue(service, forKeyPath: #keyPath(NewsSource.service))

		do {
			try context.save()
		} catch let error as NSError {
			fatalError("Couldn't insert the news source. Error: \(error)")
		}

		return newsSource
	}

	func insertNewsFeed(name: String, colorIdentifier: Int16? = -1, sources: Set<NewsSource>) {

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

	func getNewsSource(provider: String, service: String) -> NewsSource? {

		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NewsSource.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "\(#keyPath(NewsSource.provider)) == \"\(provider)\" AND \(#keyPath(NewsSource.service)) == \"\(service)\"")

		do {
			guard let sources = try context.fetch(fetchRequest) as? [NewsSource] else {
				fatalError("Couldn't convert the fetched results to [NewsSource].")
			}
			return sources.first
		} catch let error as NSError {
			fatalError("Couldn't fetch a news source. Error: \(error)")
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
