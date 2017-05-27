//
//  SourcesTableViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 05. 27..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import UIKit

class SourcesTableViewController: UITableViewController {

	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard let cell = tableView.dequeueReusableCell(withIdentifier: SourceTableViewCell.reuseIdentifier, for: indexPath) as? SourceTableViewCell else {
			fatalError("Invalid cell type. Expected SourceTableViewCell.")
		}

		let selectedIndexPaths = tableView.indexPathsForSelectedRows
		let cellIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
		cell.accessoryType = cellIsSelected ? .checkmark : .none

		// FIXME: dummy implementation
		cell.textLabel?.text = "Source"

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		guard let cell: UITableViewCell = tableView.cellForRow(at: indexPath) else {
			fatalError("Couldn't get a source cell.")
		}

		cell.accessoryType = .checkmark
	}

	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

		guard let cell: UITableViewCell = tableView.cellForRow(at: indexPath) else {
			fatalError("Couldn't get a source cell.")
		}

		cell.accessoryType = .none
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

		// FIXME: dummy implementation
		return "Header"
	}

	override func numberOfSections(in tableView: UITableView) -> Int {

		// FIXME: dummy implementation
		return 5
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		// FIXME: dummy implementation
		return 3
	}

	// MARK: - Actions

	@IBAction func cancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}

}
