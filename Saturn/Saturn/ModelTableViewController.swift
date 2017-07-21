//
//  ModelTableViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 05. 17..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import CoreData
import UIKit

class ModelTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

	// MARK: - Properties

	var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>! {

		didSet {
			fetchedResultsController.delegate = self
			performFetch()
		}
	}

	// MARK: - UITableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int {

		guard let sections = fetchedResultsController.sections else {
			fatalError("No sections in fetchedResultsController.")
		}

		return sections.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		guard let sections = fetchedResultsController.sections else {
			fatalError("No sections in fetchedResultsController.")
		}

		let sectionInfo = sections[section]

		return sectionInfo.numberOfObjects
	}

	// MARK: - NSFetchedResultsControllerDelegate

	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

		tableView.beginUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

		switch type {
		case .insert:
			guard let newIndexPath: IndexPath = newIndexPath else {
				fatalError("newIndexPath is nil at insert.")
			}
			tableView.insertRows(at: [newIndexPath], with: .fade)
		case .delete:
			guard let indexPath: IndexPath = indexPath else {
				fatalError("indexPath is nil at delete.")
			}
			tableView.deleteRows(at: [indexPath], with: .fade)
		case .update:
			guard let indexPath: IndexPath = indexPath else {
				fatalError("indexPath is nil at update.")
			}
			tableView.reloadRows(at: [indexPath], with: .fade)
		case .move:
			guard let indexPath: IndexPath = indexPath, let newIndexPath: IndexPath = newIndexPath else {
				fatalError("indexPath or newIndexPath are nil at move.")
			}
			tableView.moveRow(at: indexPath, to: newIndexPath)
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}

	// MARK: - Public Functions

	func getObject<Type>(at indexPath: IndexPath) -> Type {

		guard let object = fetchedResultsController.object(at: indexPath) as? Type else {
			fatalError("Couldn't find object at index path: \(indexPath.debugDescription)")
		}

		return object
	}

	// MARK: - Private Functions

	private func performFetch() {

		do {
			try fetchedResultsController.performFetch()
		} catch let error as NSError {
			fatalError("Failed to fetch with fetchedResultsController: \(error.debugDescription)")
		}
	}

}
