//
//  FeedTableViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 05. 16..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import CoreData
import Pastel
import UIKit

class FeedTableViewController: ModelTableViewController {

	// MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

		prepareFetchedResultsController()

		navigationItem.leftBarButtonItem = editButtonItem

		NotificationCenter.default.addObserver(self, selector: #selector(startAnimations), name: .UIApplicationDidBecomeActive, object: nil)
    }

	func prepareFetchedResultsController() {

		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NewsFeed.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(NewsFeed.order), ascending: true)]

		fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.get().modelController.context, sectionNameKeyPath: nil, cacheName: nil)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		startAnimations()
	}

	func startAnimations() {

		for cell in self.tableView.visibleCells {

			guard let cell = cell as? FeedTableViewCell else {
				fatalError("A cell on the Feeds screen is not a FeedTableViewCell.")
			}

			cell.colorPastelView.startAnimation()
		}
	}

	// MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.reuseIdentifier, for: indexPath) as? FeedTableViewCell else {
			fatalError("Invalid cell type. Expected FeedTableViewCell.")
		}

		let feed: NewsFeed = getObject(at: indexPath)

		cell.nameLabel.text = feed.name
		cell.sourcesLabel.text = getSourcesText(sources: feed.sources)
		cell.colorPastelView.setPastelGradient(getPastelGradient(colorIdentifier: feed.colorIdentifier))
		cell.colorPastelView.startAnimation()

        return cell
    }

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

		if editingStyle == .delete {
			AppDelegate.get().modelController.deleteNewsFeed(getObject(at: indexPath))
		}
	}

	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

		guard var feeds = self.fetchedResultsController?.fetchedObjects as? [NewsFeed] else {
			fatalError("Couldn't get fetched feeds.")
		}

		self.fetchedResultsController.delegate = nil

		let movedFeed = feeds.remove(at: sourceIndexPath.row)
		feeds.insert(movedFeed, at: destinationIndexPath.row)

		var order: Int16 = 0
		for feed in feeds {
			feed.order = order
			order += 1
		}

		do {
			try AppDelegate.get().modelController.context.save()
		} catch {
			fatalError("Couldn't save the reordered feeds.")
		}

		self.fetchedResultsController.delegate = self
	}

	// MARK: - Actions

	@IBAction func unwindToFeedTableViewController(sender: UIStoryboardSegue) {

		if sender.source is AddTableViewController {

			self.tableView.reloadData()
		}
	}

	// MARK: - Private Functions

	func getSourcesText(sources: NSSet?) -> String {

		let sourcesTitleSorter = NSSortDescriptor(key: #keyPath(NewsSource.title), ascending: true, selector: #selector(NSString.compare(_:)))
		let sourcesProviderSorter = NSSortDescriptor(key: #keyPath(NewsSource.provider.name), ascending: true, selector: #selector(NSString.compare(_:)))
		let sourcesQuerySorter = NSSortDescriptor(key: #keyPath(NewsSource.query), ascending: true, selector: #selector(NSString.compare(_:)))
		guard let orderedSources: [NewsSource] = sources?.sortedArray(using: [sourcesTitleSorter, sourcesProviderSorter, sourcesQuerySorter]) as? [NewsSource] else {
			fatalError("No sources given.")
		}

		var sourcesText: String = ""

		for source in orderedSources {

			var sourceText: String
			if let title: String = source.title {
				sourceText = title
			} else if let provider: String = source.provider?.name, let query: String = source.query {
				sourceText = "\(provider) - \(query)"
			} else {
				fatalError("Invalid source text.")
			}

			sourcesText = sourcesText.isEmpty ? sourceText : "\(sourcesText), \(sourceText)"
		}

		return sourcesText
	}

	func getPastelGradient(colorIdentifier: Int16) -> PastelGradient {

		let colorIdentifier = colorIdentifier == -1 ? Int(arc4random_uniform(9)) : Int(colorIdentifier)

		guard let colors: PastelGradient = PastelGradient(rawValue: colorIdentifier) else {
			fatalError("Invalid colorIdentifier for a feed.")
		}

		return colors
	}

}
