//
//  FeedTableViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 05. 16..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import CoreData
import UIKit

class FeedTableViewController: ModelTableViewController {

	// MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

		prepareFetchedResultsController()
    }

	func prepareFetchedResultsController() {

		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NewsFeed.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(NewsFeed.name), ascending: true)]

		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.modelController.context!

		fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
	}

	// MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.reuseIdentifier, for: indexPath) as? FeedTableViewCell else {
			fatalError("Invalid cell type. Expected FeedTableViewCell.")
		}

		let object: NewsFeed = getObject(at: indexPath)

		cell.nameLabel.text = object.name

        return cell
    }

}
