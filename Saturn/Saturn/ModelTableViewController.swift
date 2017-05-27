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

	var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {

		didSet {
			fetchedResultsController?.delegate = self
			performFetch()
		}
	}

	// MARK: - UITableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int {

		guard let fetchedResultsController = self.fetchedResultsController else {
			fatalError("fetchedResultsController didn't set before table view presented.")
		}

		guard let sections = fetchedResultsController.sections else {
			fatalError("No sections in fetchedResultsController.")
		}

		return sections.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		guard let fetchedResultsController = self.fetchedResultsController else {
			fatalError("fetchedResultsController didn't set before table view presented.")
		}

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
			tableView.insertRows(at: [newIndexPath!], with: .fade)
		case .delete:
			tableView.deleteRows(at: [indexPath!], with: .fade)
		case .update:
			tableView.reloadRows(at: [indexPath!], with: .fade)
		case .move:
			tableView.moveRow(at: indexPath!, to: newIndexPath!)
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}

	// MARK: - Public Functions

	func getModelController() -> ModelController {

		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.modelController
	}

	func getObject<Type>(at indexPath: IndexPath) -> Type {

		guard let fetchedResultsController = self.fetchedResultsController else {
			fatalError("fetchedResultsController didn't set yet.")
		}

		guard let object = fetchedResultsController.object(at: indexPath) as? Type else {
			fatalError("Couldn't find object at index path: \(indexPath)")
		}

		return object
	}

	// MARK: - Private Functions

	private func performFetch() {

		guard let fetchedResultsController = self.fetchedResultsController else {
			return
		}

		do {
			try fetchedResultsController.performFetch()
		} catch {
			fatalError("Failed to fetch with fetchedResultsController: \(error)")
		}
	}

}
