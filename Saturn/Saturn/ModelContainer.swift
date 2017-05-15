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

	// MARK: - Properties

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
		addNewsSource(name: "Reddit - Programming")
		addNewsSource(name: "Hacker News")
		addNewsSource(name: "HVG")
		addNewsSource(name: "Index")
	}

	// MARK: - Public Functions

	func addNewsSource(name: String, logo: UIImage? = nil) {

		let context = getContext()

		let newsSourceEntityDescription = getEntityDescription(for: "NewsSource", in: context)
		let newsSource = NSManagedObject(entity: newsSourceEntityDescription, insertInto: context)
		newsSource.setValue(name, forKeyPath: "name")
		if let logo = logo {
			guard let logoData = UIImagePNGRepresentation(logo) else {
				fatalError("Couldn't convert image to binary.")
			}
			newsSource.setValue(logoData, forKey: "logo")
		}

		do {
			try context.save()
		} catch let error as NSError {
			fatalError("Couldn't add the news source. Error: \(error)")
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
