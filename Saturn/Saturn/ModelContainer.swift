//
//  ModelContainer.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 05. 14..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import CoreData
import UIKit

class ModelContainer {

	// MARK: - Entity Names

	private let newsSourceEntityName = "NewsSource"
	private let newsFeedEntityName = "NewsFeed"

	// MARK: - Entity Properties

	private enum NewsSourceEntityProperty: String {
		case name
		case logo
		case feeds
	}

	private enum NewsFeedEntityProperty: String {
		case name
		case logo
		case sources
	}

	// MARK: - Private Properties

	private var context: NSManagedObjectContext?

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

			let isModelPreloaded = UserDefaults.standard.bool(forKey: UserDefaultsKey.isModelPreloaded.rawValue)
			if !isModelPreloaded {
				self.preloadModel()
				UserDefaults.standard.set(true, forKey: UserDefaultsKey.isModelPreloaded.rawValue)
			}
		})
	}

	private func preloadModel() {

		var sources = Set<NewsSource>()
		createNewsSource(name: "Reddit - Programming")
		sources.insert(getNewsSource(forName: "Reddit - Programming")!)
		createNewsSource(name: "Hacker News")
		sources.insert(getNewsSource(forName: "Hacker News")!)
		createNewsFeed(name: "Developer's Heaven", sources: sources)

		sources = Set<NewsSource>()
		createNewsSource(name: "HVG")
		sources.insert(getNewsSource(forName: "HVG")!)
		createNewsSource(name: "Index")
		sources.insert(getNewsSource(forName: "Index")!)
		createNewsFeed(name: "Essentials", sources: sources)
	}

	// MARK: - Public Functions

	func createNewsSource(name: String, logo: UIImage? = nil) {

		let context = getContext()

		let newsSourceEntityDescription = getEntityDescription(for: newsSourceEntityName, in: context)
		let newsSource = NSManagedObject(entity: newsSourceEntityDescription, insertInto: context)
		newsSource.setValue(name, forKeyPath: NewsSourceEntityProperty.name.rawValue)
		if let logo = logo {
			guard let logoData = UIImagePNGRepresentation(logo) else {
				fatalError("Couldn't convert image to binary.")
			}
			newsSource.setValue(logoData, forKey: NewsSourceEntityProperty.logo.rawValue)
		}

		do {
			try context.save()
		} catch let error as NSError {
			fatalError("Couldn't create the news source. Error: \(error)")
		}
	}

	func createNewsFeed(name: String, logo: UIImage? = nil, sources: Set<NewsSource>) {

		let context = getContext()

		let newsFeedEntityDescription = getEntityDescription(for: newsFeedEntityName, in: context)
		let newsFeed = NSManagedObject(entity: newsFeedEntityDescription, insertInto: context)
		newsFeed.setValue(name, forKeyPath: NewsFeedEntityProperty.name.rawValue)
		if let logo = logo {
			guard let logoData = UIImagePNGRepresentation(logo) else {
				fatalError("Couldn't convert image to binary.")
			}
			newsFeed.setValue(logoData, forKey: NewsFeedEntityProperty.logo.rawValue)
		}
		newsFeed.setValue(sources, forKey: NewsFeedEntityProperty.sources.rawValue)

		do {
			try context.save()
		} catch let error as NSError {
			fatalError("Couldn't create the news feed. Error: \(error)")
		}
	}

	func getNewsSource(forName name: String) -> NewsSource? {

		let context = getContext()

		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: newsSourceEntityName)
		fetchRequest.predicate = NSPredicate(format: "name == %@", name)

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
