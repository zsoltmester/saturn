//
//  FeedListTableViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 05. 16..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import CoreData
import UIKit

class FeedListTableViewController: ModelTableViewController {

	// MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableViewAutomaticDimension

		navigationItem.leftBarButtonItem = editButtonItem

		prepareFetchedResultsController()
    }

	private func prepareFetchedResultsController() {

		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NewsFeed.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(NewsFeed.order), ascending: true)]

		fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ModelController.shared.context, sectionNameKeyPath: nil, cacheName: nil)
	}

	// MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.reuseIdentifier, for: indexPath) as? FeedTableViewCell else {
			fatalError("Invalid cell type. Expected FeedTableViewCell.")
		}

		let feed: NewsFeed = getObject(at: indexPath)

		guard let sources = feed.sources else {
			fatalError("No sources for a feed: \(feed.debugDescription)")
		}

		cell.nameLabel.text = feed.name
		cell.sourcesLabel.attributedText = getSourcesText(sources: sources)

        return cell
    }

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

		if editingStyle == .delete {
			ModelController.shared.deleteNewsFeed(getObject(at: indexPath))
		}
	}

	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

		guard var feeds = self.fetchedResultsController?.fetchedObjects as? [NewsFeed] else {
			fatalError("Couldn't get fetched feeds at reorder.")
		}

		let movedFeed = feeds.remove(at: sourceIndexPath.row)
		feeds.insert(movedFeed, at: destinationIndexPath.row)

		var order: Int16 = 0
		for feed in feeds {
			feed.order = order
			order += 1
		}

		do {
			self.fetchedResultsController.delegate = nil
			try ModelController.shared.context.save()
			prepareFetchedResultsController()
		} catch let error as NSError {
			fatalError("Couldn't save the reordered feeds: \(error.debugDescription)")
		}
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		if tableView.isEditing {

			performSegue(withIdentifier: "Edit Feed", sender: indexPath)
		}
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)

		switch segue.identifier ?? "" {

		case "Edit Feed":

			guard let senderIndexPath = sender as? IndexPath, let feed: NewsFeed = getObject(at: senderIndexPath) else {
				fatalError("At Edit Feed segue the sender is not a valid index path, but \(sender ?? "nil").")
			}

			guard let feedEditorTableViewController = segue.destination.childViewControllers[0] as? FeedEditorTableViewController else {
				fatalError("At Edit Feed segue the destination view controller's first child is not a FeedEditorTableViewController, but \(segue.destination.debugDescription).")
			}

			feedEditorTableViewController.feedToEdit = feed

		case "Show Feed":

			guard let cell = sender as? FeedTableViewCell else {
				fatalError("At Show Feed segue the sender is not a FeedTableViewCell, but \(sender ?? "nil").")
			}

			guard let cellIndexPath = tableView.indexPath(for: cell), let feed: NewsFeed = getObject(at: cellIndexPath) else {
				fatalError("At Show Feed segue couldn't get feed for a cell.")
			}

			guard let newsTableViewController = segue.destination as? NewsTableViewController else {
				fatalError("At Show Feed segue the destination view controller is not a NewsTableViewController, but \(segue.destination.debugDescription).")
			}

			newsTableViewController.feed = feed

		default:

			break
		}
	}

	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		super.shouldPerformSegue(withIdentifier: identifier, sender: sender)

		switch identifier {

		case "Show Feed":

			return !tableView.isEditing

		default:

			return true
		}
	}

	// MARK: - Actions

	@IBAction func unwindToFeedListTableViewController(sender: UIStoryboardSegue) {

		if sender.source is FeedEditorTableViewController {

			self.tableView.reloadData()
		}
	}

	// MARK: - Private Functions

	private func getSourcesText(sources: NSSet) -> NSAttributedString {

		let sourcesProviderSorter = NSSortDescriptor(key: #keyPath(NewsSource.provider.name), ascending: true, selector: #selector(NSString.compare(_:)))
		let sourcesNameSorter = NSSortDescriptor(key: #keyPath(NewsSource.name), ascending: true, selector: #selector(NSString.compare(_:)))
		guard let orderedSources = sources.sortedArray(using: [sourcesProviderSorter, sourcesNameSorter]) as? [NewsSource] else {
			fatalError("The given sources are not [NewsSource] after the sort.")
		}

		var groupedAndOrderedSources = [(provider: NewsProvider, sources: [NewsSource])]()

		for source in orderedSources {

			if let groupIndex = groupedAndOrderedSources.index(where: { $0.provider.identifier == source.provider?.identifier }) {

				groupedAndOrderedSources[groupIndex].sources.append(source)

			} else {

				guard let provider = source.provider else {
					fatalError("No provider for a source: \(source.debugDescription)")
				}

				groupedAndOrderedSources.append((provider: provider, sources: [source]))
			}
		}

		var sourcesText = NSMutableAttributedString(string: "")

		for i in 0..<groupedAndOrderedSources.count {

			guard let providerName = groupedAndOrderedSources[i].provider.name else {
				fatalError("No name for a provider: \(groupedAndOrderedSources[i].provider.debugDescription)")
			}

			let textForProvider = NSMutableAttributedString(string: "\(providerName): ")
			textForProvider.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkText, range: NSRange(location: 0, length: textForProvider.length))

			for source in groupedAndOrderedSources[i].sources {

				guard let sourceName = source.name else {
					fatalError("No name for a source: \(source.debugDescription)")
				}

				if source === groupedAndOrderedSources[i].sources.first {

					textForProvider.append(NSAttributedString(string: sourceName))

				} else {

					textForProvider.append(getSourceSeparator())
					textForProvider.append(NSAttributedString(string: sourceName))
				}
			}

			if sourcesText.length == 0 {

				sourcesText = textForProvider

			} else {

				sourcesText.append(getSourceSeparator())
				sourcesText.append(textForProvider)
			}
		}

		return sourcesText
	}

	func getSourceSeparator() -> NSAttributedString {

		let comma = NSMutableAttributedString(string: ", ")
		comma.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkText, range: NSRange(location: 0, length: comma.length))
		return comma
	}

}
