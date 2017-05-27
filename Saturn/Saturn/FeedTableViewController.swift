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

		let feed: NewsFeed = getObject(at: indexPath)

		cell.nameLabel.text = feed.name
		cell.sourcesLabel.text = getSourcesText(sources: feed.sources)

		cell.colorsPastelView.layer.cornerRadius = 10.0
		cell.colorsPastelView.layer.masksToBounds = true
		cell.colorsPastelView.startPastelPoint = .top
		cell.colorsPastelView.endPastelPoint = .bottom
		cell.colorsPastelView.setPastelGradient(getPastelGradient(colorsIdentifier: feed.colorsIdentifier))
		cell.colorsPastelView.animationDuration = 2;
		cell.colorsPastelView.startAnimation()

        return cell
    }

	// MARK: - Private Functions

	func getSourcesText(sources: NSSet?) -> String {

		let sourcesSorter = [NSSortDescriptor(key: #keyPath(NewsSource.name), ascending: true, selector: #selector(NSString.compare(_:)))]
		guard let orderedSources: [NewsSource] = sources?.sortedArray(using: sourcesSorter) as? [NewsSource] else {
			fatalError("No sources given.")
		}

		var sourcesText: String = ""
		for source in orderedSources {
			sourcesText = sourcesText.isEmpty ? source.name! : "\(sourcesText), \(source.name!)"
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
