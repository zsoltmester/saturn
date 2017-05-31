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
    }

	func prepareFetchedResultsController() {

		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NewsFeed.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(NewsFeed.order), ascending: true)]

		fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: getModelController().context!, sectionNameKeyPath: nil, cacheName: nil)
	}

	// MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.reuseIdentifier, for: indexPath) as? FeedTableViewCell else {
			fatalError("Invalid cell type. Expected FeedTableViewCell.")
		}

		let feed: NewsFeed = getObject(at: indexPath)

		cell.nameLabel.text = feed.name
		cell.sourcesLabel.text = getSourcesText(sources: feed.sources)
		cell.colorsPastelView.setPastelGradient(getPastelGradient(colorsIdentifier: feed.colorsIdentifier))

		// FIXME: should be in the view (FeedTableViewCell)
		cell.colorsPastelView.layer.cornerRadius = 10.0
		cell.colorsPastelView.layer.masksToBounds = true
		cell.colorsPastelView.startPastelPoint = .top
		cell.colorsPastelView.endPastelPoint = .bottom
		cell.colorsPastelView.animationDuration = 2;

        return cell
    }

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

		guard let cell = cell as? FeedTableViewCell else {
			fatalError("Invalid cell type. Expected FeedTableViewCell.")
		}

		// FIXME: should be in the view (FeedTableViewCell)
		cell.colorsPastelView.startAnimation()
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

		if editingStyle == .delete {
			getModelController().deleteNewsFeed(getObject(at: indexPath))
		}
	}

	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

		guard var feeds = self.fetchedResultsController?.fetchedObjects as? [NewsFeed] else {
			fatalError("Couldn't get fetched feeds.")
		}

		self.fetchedResultsController!.delegate = nil

		let movedFeed = feeds.remove(at: sourceIndexPath.row)
		feeds.insert(movedFeed, at: destinationIndexPath.row)

		var order: Int16 = 0
		for feed in feeds {
			feed.order = order
			order += 1
		}

		do {
			try getModelController().context!.save()
		} catch {
			fatalError("Couldn't save the reordered feeds.")
		}

		self.fetchedResultsController!.delegate = self
	}

	// MARK: - Private Functions

	func getSourcesText(sources: NSSet?) -> String {

		let sourcesProviderSorter = NSSortDescriptor(key: #keyPath(NewsSource.provider), ascending: true, selector: #selector(NSString.compare(_:)))
		let sourcesServiceSorter = NSSortDescriptor(key: #keyPath(NewsSource.service), ascending: true, selector: #selector(NSString.compare(_:)))
		guard let orderedSources: [NewsSource] = sources?.sortedArray(using: [sourcesProviderSorter, sourcesServiceSorter]) as? [NewsSource] else {
			fatalError("No sources given.")
		}

		var sourcesText: String = ""
		for source in orderedSources {
			let sourceText: String = source.provider! == source.service ? source.provider! : "\(source.provider!) - \(source.service!)"
			sourcesText = sourcesText.isEmpty ? sourceText : "\(sourcesText), \(sourceText)"
		}

		return sourcesText
	}

	func getPastelGradient(colorsIdentifier: Int16) -> PastelGradient {
		
		let colorsIdentifier = colorsIdentifier == -1 ? Int(arc4random_uniform(9)) : Int(colorsIdentifier)

		guard let colors: PastelGradient = PastelGradient(rawValue: colorsIdentifier) else {
			fatalError("Invalid colorsIdentifier for a feed.")
		}

		return colors;
	}

}
