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
	
	var context: NSManagedObjectContext?

	// MARK: - Initialization

	init() {

		let container = NSPersistentContainer(name: "Saturn")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in

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
		insertNewsSource(name: "BBC News")
		sources.insert(getNewsSource(forName: "BBC News")!)
		insertNewsSource(name: "CNN")
		sources.insert(getNewsSource(forName: "CNN")!)
		insertNewsSource(name: "Telegraph")
		sources.insert(getNewsSource(forName: "Telegraph")!)
		insertNewsSource(name: "The Guardian")
		sources.insert(getNewsSource(forName: "The Guardian")!)
		insertNewsSource(name: "The New York Times")
		sources.insert(getNewsSource(forName: "The New York Times")!)
		insertNewsFeed(name: "International News", colorsIdentifier:6, sources: sources)

		sources.removeAll()
		insertNewsSource(name: "heartstone.com")
		sources.insert(getNewsSource(forName: "heartstone.com")!)
		insertNewsFeed(name: "Hearthstone", colorsIdentifier:9, sources: sources)

		sources.removeAll()
		insertNewsSource(name: "9gag")
		sources.insert(getNewsSource(forName: "9gag")!)
		insertNewsSource(name: "Reddit - Aww")
		sources.insert(getNewsSource(forName: "Reddit - Aww")!)
		insertNewsFeed(name: "Chill", colorsIdentifier:5, sources: sources)


		sources.removeAll()
		insertNewsSource(name: "Reddit - Programming")
		sources.insert(getNewsSource(forName: "Reddit - Programming")!)
		insertNewsSource(name: "Hacker News")
		sources.insert(getNewsSource(forName: "Hacker News")!)
		insertNewsFeed(name: "Developer's Heaven", colorsIdentifier:1, sources: sources)

		sources.removeAll()
		insertNewsSource(name: "HVG")
		sources.insert(getNewsSource(forName: "HVG")!)
		insertNewsSource(name: "Index")
		sources.insert(getNewsSource(forName: "Index")!)
		insertNewsSource(name: "444")
		sources.insert(getNewsSource(forName: "444")!)
		insertNewsFeed(name: "Daily Essentials", colorsIdentifier:4, sources: sources)
	}

	// MARK: - Public Functions

	func insertNewsSource(name: String, logo: UIImage? = nil) {

		let context = getContext()

		let newsSourceEntityDescription = getEntityDescription(for: String(describing: NewsSource.self), in: context)
		let newsSource = NSManagedObject(entity: newsSourceEntityDescription, insertInto: context)
		newsSource.setValue(name, forKeyPath: #keyPath(NewsSource.name))
		if let logo = logo {
			guard let logoData = UIImagePNGRepresentation(logo) else {
				fatalError("Couldn't convert image to binary.")
			}
			newsSource.setValue(logoData, forKey: #keyPath(NewsSource.logo))
		}

		do {
			try context.save()
		} catch let error as NSError {
			fatalError("Couldn't insert the news source. Error: \(error)")
		}
	}

	func insertNewsFeed(name: String, colorsIdentifier: Int16? = -1, sources: Set<NewsSource>) {

		let context = getContext()

		let newsFeedEntityDescription = getEntityDescription(for: String(describing: NewsFeed.self), in: context)
		let newsFeed = NSManagedObject(entity: newsFeedEntityDescription, insertInto: context)
		newsFeed.setValue(name, forKeyPath: #keyPath(NewsFeed.name))
		newsFeed.setValue(colorsIdentifier, forKey: #keyPath(NewsFeed.colorsIdentifier))
		newsFeed.setValue(sources, forKey: #keyPath(NewsFeed.sources))
		newsFeed.setValue(getNewsFeedOrderMin() - 1, forKey: #keyPath(NewsFeed.order))

		do {
			try context.save()
		} catch let error as NSError {
			fatalError("Couldn't insert the news feed. Error: \(error)")
		}
	}

	func getNewsSource(forName name: String) -> NewsSource? {

		let context = getContext()

		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NewsSource.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "\(#keyPath(NewsSource.name)) == \"\(name)\"")

		do {
			guard let sources = try context.fetch(fetchRequest) as? [NewsSource] else {
				fatalError("Couldn't convert the fetched results to [NewsSource].")
			}
			return sources.first;
		} catch let error as NSError {
			fatalError("Couldn't fetch the news source: \(name). Error: \(error)")
		}
	}

	// MARK: - Private Functions

	private func getContext() -> NSManagedObjectContext {

		guard let context = self.context else {
			fatalError("The context is unavailable.")
		}

		return context
	}

	private func getEntityDescription(for entityName: String, in context: NSManagedObjectContext) -> NSEntityDescription {

		guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
			fatalError("Didn't find entity with name: \(entityName)")
		}

		return entityDescription
	}

	private func getNewsFeedOrderMin() -> Int16 {

		let context = getContext()

		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NewsFeed.fetchRequest()
		fetchRequest.resultType = .dictionaryResultType;

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
