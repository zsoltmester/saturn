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

	/*override func viewDidLoad() {
		super.viewDidLoad()

		let feeds = loadFeeds()
		NSLog(feeds.description)
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
	}*/
}

