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

	// MARK: - Table View Data Source

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

	// MARK: - Public Functions

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
