//
//  ViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 05. 11..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import CoreData
import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		saveFeed(withName: "HVG")

		let feeds = loadFeeds()
		NSLog(feeds.description)
	}

	func saveFeed(withName: String) {

		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		guard let modelContext = appDelegate.model.context else {
			fatalError("Model didn't load yet.")
		}

		let newsFeedEntity = NSEntityDescription.entity(forEntityName: "NewsFeed", in: modelContext)!

		let hvgFeed = NSManagedObject(entity: newsFeedEntity, insertInto: modelContext)
		hvgFeed.setValue("HVG", forKeyPath: "name")

		let indexFeed = NSManagedObject(entity: newsFeedEntity, insertInto: modelContext)
		indexFeed.setValue("Index", forKeyPath: "name")

		do {
			try modelContext.save()
		} catch let error as NSError {
			fatalError("Couldn't save the feeds. Error: \(error), \(error.userInfo)")
		}
	}

	func loadFeeds() -> [NewsFeed] {

		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		guard let modelContext = appDelegate.model.context else {
			fatalError("Model didn't load yet.")
		}

		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NewsFeed")

		do {
			guard let feeds = try modelContext.fetch(fetchRequest) as? [NewsFeed] else {
				fatalError("Couldn't convert the fetched feeds to [NewsFeed].")
			}
			return feeds;
		} catch let error as NSError {
			fatalError("Couldn't fetch the feeds. Error:  \(error), \(error.userInfo)")
		}
	}
}

