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
		insertNewsSource(name: "Reddit - Programming")
		sources.insert(getNewsSource(forName: "Reddit - Programming")!)
		insertNewsSource(name: "Hacker News")
		sources.insert(getNewsSource(forName: "Hacker News")!)
		insertNewsFeed(name: "Developer's Heaven", sources: sources)

		sources.removeAll()
		insertNewsSource(name: "HVG")
		sources.insert(getNewsSource(forName: "HVG")!)
		insertNewsSource(name: "Index")
		sources.insert(getNewsSource(forName: "Index")!)
		insertNewsFeed(name: "Daily Essentials", sources: sources)

		sources.removeAll()
		insertNewsSource(name: "9gag")
		sources.insert(getNewsSource(forName: "9gag")!)
		insertNewsSource(name: "Reddit - Aww")
		sources.insert(getNewsSource(forName: "Reddit - Aww")!)
		insertNewsFeed(name: "Chill", sources: sources)

		sources.removeAll()
		insertNewsSource(name: "Heartstone")
		sources.insert(getNewsSource(forName: "Heartstone")!)
		insertNewsFeed(name: "Hearthstone", sources: sources)
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

	func insertNewsFeed(name: String, logo: UIImage? = nil, sources: Set<NewsSource>) {

		let context = getContext()

		let newsFeedEntityDescription = getEntityDescription(for: String(describing: NewsFeed.self), in: context)
		let newsFeed = NSManagedObject(entity: newsFeedEntityDescription, insertInto: context)
		newsFeed.setValue(name, forKeyPath: #keyPath(NewsFeed.name))
		if let logo = logo {
			guard let logoData = UIImagePNGRepresentation(logo) else {
				fatalError("Couldn't convert image to binary.")
			}
			newsFeed.setValue(logoData, forKey: #keyPath(NewsFeed.logo))
		}
		newsFeed.setValue(sources, forKey: #keyPath(NewsFeed.sources))

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
			fatalError("Couldn't fetch the news source: \(name). Error:  \(error)")
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

}
